import 'dart:async';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/create_edit_playlist/edit_playlist_cubit.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/create_edit_playlist/playlists_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/dialogs/confirmation_dialog.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../../core/utils/private_playlist_botttom_sheet_widget.dart';
import '../../../Playlists/presentation/cubits/my_playlists/my_playlists_cubit.dart';
import '../../../Playlists/presentation/cubits/remove_playlist/remove_playlist_cubit.dart';
import '../../../Playlists/presentation/cubits/remove_song_from_playlists/remove_song_from_playlists_cubit.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/domain/entities/Songs_PlayLists.dart';
import '../../../search_song/presentation/search_song/search_song_screen.dart';
import '../cubit/audio_playlists_cubit.dart';
import 'loading.dart';

// di.sl<MainController>()
class AudioPlayListsScreen extends StatefulWidget {
  AudioPlayListsScreen({
    required this.songsPlayLists,
    this.ispublic = false,
    Key? key,
  }) : super(key: key);
  SongsPlayLists songsPlayLists;
  bool ispublic;

  @override
  State<AudioPlayListsScreen> createState() => _AudioPlayListsScreenState();
}

class _AudioPlayListsScreenState extends State<AudioPlayListsScreen> {
  ScrollController scrollController = ScrollController();

  void _getAudioPlayLists() {
    BlocProvider.of<AudioPlayListsCubit>(context).getAudioPlayLists(
      id: widget
          .songsPlayLists.id, //songsPlayLists.id, //widget.songsPlayLists.id,
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<AudioPlayListsCubit>(context).pageNo <=
                BlocProvider.of<AudioPlayListsCubit>(context).totalPages) {
          _getAudioPlayLists();
        }
      }
    });
  }

  removefromPlaylists({
    required int songId,
  }) {
    BlocProvider.of<RemoveSongFromPlaylistsCubit>(context)
        .removeSongFromPlaylists(
      songId: songId,
      playListsId: widget.songsPlayLists.id!,
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
    );
  }

  @override
  void initState() {
    BlocProvider.of<AudioPlayListsCubit>(context).clearData();

    _getAudioPlayLists();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return MultiBlocListener(
      listeners: [
        BlocListener<RemoveSongFromPlaylistsCubit,
            RemoveSongFromPlaylistsState>(
          listener: (context, state) {
            if (state is RemoveSongFromPlaylistsSuccess) {
              Constants.showToast(
                message: AppLocalizations.of(context)!
                    .translate("song_removed_from_playlist")!,
              );
              BlocProvider.of<AudioPlayListsCubit>(context).clearData();
              _getAudioPlayLists();
            }
            if (state is RemoveSongFromPlaylistsLoading) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
        ),
        BlocListener<EditPlaylistCubit, PlaylistState>(
          listener: (context, state) {
            if (state is PlaylistSuccess) {
              Constants.showToast(message: AppLocalizations.of(context)!
                    .translate("your_playlist_updated.")!,);
              _getAudioPlayLists();

              BlocProvider.of<MyPlaylistsCubit>(context).clearData();
              BlocProvider.of<MyPlaylistsCubit>(context).getMyPlaylists(
                accessToken:
                    context.read<LoginCubit>().authenticatedUser!.accessToken,
              );
            }

            if (state is PlaylistError) {
              Constants.showToast(message: state.error);
            }
          },
        ),
        BlocListener<RemovePlaylistCubit, RemovePlaylistState>(
          listener: (context, state) {
            if (state is RemovePlaylistSuccess) {
              Constants.showToast(message: state.message);
              Navigator.of(context).pop();
              BlocProvider.of<MyPlaylistsCubit>(context).clearData();
              BlocProvider.of<MyPlaylistsCubit>(context).getMyPlaylists(
                accessToken:
                    context.read<LoginCubit>().authenticatedUser!.accessToken,
              );
            }
            if (state is RemovePlaylistFailed) {
              Constants.showToast(message: state.message);
            }
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          // key: scaffoldKey,
          body: ReusedBackground(
            body: BlocBuilder<AudioPlayListsCubit, AudioPlayListsState>(
              builder: (context, state) {
                if (state is AudioPlayListsIsLoading && state.isFirstFetch) {
                  return const LoadingScreen();
                }
                if (state is AudioPlayListsIsLoading) {
                  BlocProvider.of<AudioPlayListsCubit>(context).loadMore = true;
                } else if (state is AudioPlayListsError) {
                  return error_widget.ErrorWidget(
                    onRetryPressed: () => _getAudioPlayLists(),
                    msg: state.message!,
                  );
                }

                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: context.height * 0.017,
                        ),
                        Row(
                          children: [
                            const BackArrow(),
                            SizedBox(
                              width: context.height * 0.017,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  BlocProvider.of<AudioPlayListsCubit>(
                                    context,
                                  ).playListsDetails!.title!,
                                  style: styleW600(context)!
                                      .copyWith(fontSize: FontSize.f18),
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            // const Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    pushNavigate(
                                      context,
                                      SearchSongScreen(
                                        songs: BlocProvider.of<
                                                AudioPlayListsCubit>(context)
                                            .audioPlayLists,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.search,
                                  ),
                                ),
                                if (widget.ispublic)
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        useSafeArea: true,
                                        useRootNavigator: true,
                                        // isScrollControlled: true, // Allow the sheet to adjust height based on content
                                        elevation: 3,
                                        backgroundColor: Colors.black,
                                        context: context,
                                        builder: (context) {
                                          return SingleChildScrollView(
                                            child: FractionallySizedBox(
                                              alignment: Alignment.topCenter,
                                              child: PrivatePlaylistSheetWidget(
                                                playListsDetails: BlocProvider
                                                    .of<AudioPlayListsCubit>(
                                                  context,
                                                ).playListsDetails!,
                                                songs: BlocProvider.of<
                                                    AudioPlayListsCubit>(
                                                  context,
                                                ).audioPlayLists,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                    ),
                                  )
                                else
                                  const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              // borderRadius: new BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageUrl: BlocProvider.of<AudioPlayListsCubit>(
                                  context,
                                ).playListsDetails!.artworkUrl!,
                                width: MediaQuery.of(context).size.width / 3,
                                height: 100,
                                maxHeightDiskCache: 100,
                                maxWidthDiskCache: 100,
                                memCacheHeight: (50 *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                                memCacheWidth: (50 *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                                progressIndicatorBuilder: (context, url, l) =>
                                    const LoadingImage(),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' ${BlocProvider.of<AudioPlayListsCubit>(
                                      context,
                                    ).playListsDetails!.title!}',
                                    maxLines: 2,
                                    style: styleW500(context)!
                                        .copyWith(fontSize: FontSize.f16),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    ' ${BlocProvider.of<AudioPlayListsCubit>(
                                      context,
                                    ).playListsDetails!.description!}',
                                    style: styleW400(context)!
                                        .copyWith(fontSize: FontSize.f12),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    ' ${BlocProvider.of<AudioPlayListsCubit>(
                                      context,
                                    ).playListsDetails!.songCount} ${AppLocalizations.of(context)!.translate("songs")}',
                                    style: styleW500(context)!
                                        .copyWith(fontSize: FontSize.f16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: BlocProvider.of<AudioPlayListsCubit>(context)
                                  .audioPlayLists
                                  .isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppPadding.pDefault,
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsetsDirectional.only(
                                      top: AppPadding.p20,
                                      bottom: AppPadding.p20 * 6,
                                    ),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: AppPadding.p20,
                                    ),
                                    itemCount: BlocProvider.of<
                                            AudioPlayListsCubit>(
                                          context,
                                        ).audioPlayLists.length +
                                        (BlocProvider.of<AudioPlayListsCubit>(
                                          context,
                                        ).loadMore
                                            ? 1
                                            : 0),
                                    itemBuilder: (context, index) {
                                      if (index <
                                          BlocProvider.of<AudioPlayListsCubit>(
                                            context,
                                          ).audioPlayLists.length) {
                                        return GestureDetector(
                                          onTap: () {
                                            final con =
                                                Provider.of<MainController>(
                                              context,
                                              listen: false,
                                            );
                                            con.playSong(
                                              con.convertToAudio(
                                                BlocProvider.of<
                                                    AudioPlayListsCubit>(
                                                  context,
                                                ).audioPlayLists,
                                              ),
                                              BlocProvider.of<
                                                      AudioPlayListsCubit>(
                                                context,
                                              ).audioPlayLists.indexOf(
                                                    BlocProvider.of<
                                                        AudioPlayListsCubit>(
                                                      context,
                                                    ).audioPlayLists[index],
                                                  ),
                                            );
                                          },
                                          child: SongItem(
                                            songs: BlocProvider.of<
                                                AudioPlayListsCubit>(
                                              context,
                                            ).audioPlayLists[index],
                                            menuItem: MenuItemButtonWidget(
                                              deleteIcon: widget.ispublic
                                                  ? IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (
                                                            BuildContext
                                                                context,
                                                          ) =>
                                                              ConfirmationDialog(
                                                            alertMsg: AppLocalizations
                                                                        .of(
                                                                  context,
                                                                )!
                                                                    .translate(
                                                                  'want_to_remove',
                                                                )! +
                                                                BlocProvider.of<
                                                                        AudioPlayListsCubit>(
                                                                  context,
                                                                )
                                                                    .audioPlayLists[
                                                                        index]
                                                                    .title!,
                                                            onTapConfirm: () =>
                                                                removefromPlaylists(
                                                              songId: BlocProvider.of<
                                                                      AudioPlayListsCubit>(
                                                                context,
                                                              )
                                                                  .audioPlayLists[
                                                                      index]
                                                                  .id!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete_forever,
                                                        color: AppColors
                                                            .cGreyColor,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              song: BlocProvider.of<
                                                  AudioPlayListsCubit>(
                                                context,
                                              ).audioPlayLists[index],
                                            ),
                                          ),
                                        );
                                      } else if (BlocProvider.of<
                                              AudioPlayListsCubit>(
                                            context,
                                          ).pageNo <=
                                          BlocProvider.of<AudioPlayListsCubit>(
                                            context,
                                          ).totalPages) {
                                        Timer(const Duration(milliseconds: 30),
                                            () {
                                          scrollController.jumpTo(
                                            scrollController
                                                .position.maxScrollExtent,
                                          );
                                        });

                                        return const LoadingIndicator();
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                )
                              : const Center(
                                  child: NoData(),
                                ),
                        ),
                      ],
                    ),
                    BlocBuilder<RemovePlaylistCubit, RemovePlaylistState>(
                      builder: (context, state) {
                        return state is RemovePlaylistLoading
                            ? Container(
                                alignment: Alignment.center,
                                color: Colors.black.withOpacity(0.3),
                                child: const CircularProgressIndicator(),
                              )
                            : const SizedBox();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
