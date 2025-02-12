import 'dart:async';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/dialogs/confirmation_dialog.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../Playlists/presentation/cubits/remove_song_from_playlists/remove_song_from_playlists_cubit.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../drawer/presentation/screens/drawer_screen.dart';
import '../../../home/domain/entities/Songs_PlayLists.dart';
import '../cubit/audio_playlists_cubit.dart';
import 'loading.dart';

// di.sl<MainController>()
class AudioPlayListsScreen extends StatefulWidget {
  const AudioPlayListsScreen({
    required this.songsPlayLists,
    Key? key,
  }) : super(key: key);
  final SongsPlayLists songsPlayLists;

  @override
  State<AudioPlayListsScreen> createState() => _AudioPlayListsScreenState();
}

class _AudioPlayListsScreenState extends State<AudioPlayListsScreen> {
  ScrollController scrollController = ScrollController();

  getAudioPlayLists() {
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
          getAudioPlayLists();
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

    getAudioPlayLists();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocListener<RemoveSongFromPlaylistsCubit,
        RemoveSongFromPlaylistsState>(
      listener: (context, state) {
        if (state is RemoveSongFromPlaylistsSuccess) {
          Constants.showToast(
            message: "Song removed from playlist.",
          );
          BlocProvider.of<AudioPlayListsCubit>(context).clearData();

          getAudioPlayLists();
        }
        if (state is RemoveSongFromPlaylistsLoading) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: SafeArea(
        child: Scaffold(
          // key: scaffoldKey,
          drawer: const DrawerScreen(),
          body: ReusedBackground(
            lightBG: ImagesPath.homeBGLightBG,
            body: Column(
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
                    Center(
                      child: Text(
                        widget.songsPlayLists.title!,
                        style: styleW600(context)!
                            .copyWith(fontSize: FontSize.f18),
                      ),
                    ),
                  ],
                ),
                Stack(
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
                        imageUrl: widget.songsPlayLists.artworkUrl!,
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        maxHeightDiskCache: 100,
                        maxWidthDiskCache: 100,
                        memCacheHeight:
                            (50 * MediaQuery.of(context).devicePixelRatio)
                                .round(),
                        memCacheWidth:
                            (50 * MediaQuery.of(context).devicePixelRatio)
                                .round(),
                        progressIndicatorBuilder: (context, url, l) =>
                            const LoadingImage(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: context.height * 0.116,
                      right: 0.0,
                      left: 0.0,
                      // alignment: Alignment.bottomCenter,
                      child: Text(
                        widget.songsPlayLists.title!,
                        style: styleW700(context, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<AudioPlayListsCubit, AudioPlayListsState>(
                    builder: (context, state) {
                      if (state is AudioPlayListsIsLoading &&
                          state.isFirstFetch) {
                        return const LoadingIndicator();
                      }
                      if (state is AudioPlayListsIsLoading) {
                        BlocProvider.of<AudioPlayListsCubit>(context).loadMore =
                            true;
                      } else if (state is AudioPlayListsError) {
                        return error_widget.ErrorWidget(
                          onRetryPressed: () => getAudioPlayLists(),
                          msg: state.message!,
                        );
                      }

                      return BlocProvider.of<AudioPlayListsCubit>(context)
                              .audioPlayLists
                              .isNotEmpty
                          ? 
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.pDefault,
                              ),
                              child: 
                              ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsetsDirectional.only(
                                  top: AppPadding.p20,
                                  bottom: AppPadding.p20 * 6,
                                ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: scrollController,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: AppPadding.p20,
                                ),
                                itemCount: BlocProvider.of<AudioPlayListsCubit>(
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
                                    // final bool isPlaying = widget
                                    //         .con.player.getCurrentAudioTitle ==
                                    //     BlocProvider.of<AudioPlayListsCubit>(
                                    //       context,
                                    //     ).audioPlayLists[index].title;

                                    // log('isPlaying audiooooo$isPlaying ');

                                    return GestureDetector(
                                      onTap: () {
                                        final con = Provider.of<MainController>(
                                            context,
                                            listen: false,);
                                        con.playSong(
                                          con.convertToAudio(
                                            BlocProvider.of<
                                                AudioPlayListsCubit>(
                                              context,
                                            ).audioPlayLists,
                                          ),
                                          BlocProvider.of<AudioPlayListsCubit>(
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
                                          deleteIcon: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        ConfirmationDialog(
                                                  alertMsg: AppLocalizations.of(
                                                        context,
                                                      )!
                                                          .translate(
                                                        'want_to_remove',
                                                      )! +
                                                      BlocProvider.of<
                                                              AudioPlayListsCubit>(
                                                        context,
                                                      )
                                                          .audioPlayLists[index]
                                                          .title!,
                                                  onTapConfirm: () =>
                                                      removefromPlaylists(
                                                    songId: BlocProvider.of<
                                                        AudioPlayListsCubit>(
                                                      context,
                                                    ).audioPlayLists[index].id!,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              color: AppColors.cGreyColor,
                                            ),
                                          ),
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
                                    Timer(const Duration(milliseconds: 30), () {
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
                              child: Text('no data'),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
