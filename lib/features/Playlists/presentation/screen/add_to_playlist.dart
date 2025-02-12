import 'dart:async';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/components/reused_background.dart';
import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/constants.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/features/auth/presentation/widgets/gradient_auth_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/entities/songs.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/no_data.dart';
import '../../../audio_playlists/presentation/screen/loading.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../cubits/add_song_to_playlists/add_song_to_playlists_cubit.dart';
import '../cubits/create_playlists/create_playlists_cubit.dart';
import '../cubits/my_playlists/my_playlists_cubit.dart';

class AddToPlaylist extends StatefulWidget {
  Songs? song;

  AddToPlaylist({
    Key? key,
    this.song,
  }) : super(key: key);

  @override
  State<AddToPlaylist> createState() => _AddToMyPlaylistState();
}

class _AddToMyPlaylistState extends State<AddToPlaylist> {
  ScrollController scrollController = ScrollController();

  getMyPlaylists() {
    BlocProvider.of<MyPlaylistsCubit>(context).getMyPlaylists(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  createPlaylists({required String playlistName}) {
    BlocProvider.of<CreatePlaylistsCubit>(context).createPlaylists(
      playlistName: playlistName,
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
    );
  }

  addtoPlaylists({required int mediaId, required int playListsId}) {
    BlocProvider.of<AddSongToPlaylistsCubit>(context).addSongToPlaylists(
      mediaId: mediaId,
      playListsId: playListsId,
      mediaType: AppStrings.song,
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<MyPlaylistsCubit>(context).pageNo <=
                BlocProvider.of<MyPlaylistsCubit>(context).totalPages) {
          getMyPlaylists();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<MyPlaylistsCubit>(context).clearData();

    getMyPlaylists();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController con = TextEditingController();

    return MultiBlocListener(
      listeners: [
        BlocListener<CreatePlaylistsCubit, CreatePlaylistsState>(
          listener: (context, state) {
            if (state is CreatePlaylistsSuccess) {
              Navigator.of(context).pop();
              BlocProvider.of<MyPlaylistsCubit>(context).clearData();
              getMyPlaylists();
            }
          },
        ),
        BlocListener<AddSongToPlaylistsCubit, AddSongToPlaylistsState>(
          listener: (context, state) {
            if (state is AddSongToPlaylistsSuccess) {
              Constants.showToast(
                message: "Song added to playlist.",
              );
              Navigator.pop(context);
              Navigator.of(context).pop();
            }
          },
        ),
        // BlocListener<BlocC, BlocCState>(
        //   listener: (context, state) {},
        // ),
      ],
      child: Scaffold(
        // key: scaffoldKey,
        // drawer: const DrawerScreen(),

        body: ReusedBackground(
          lightBG: ImagesPath.homeBGLightBG,
          body: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const BackArrow(),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate("add_to_Playlist")!,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.017,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .87,
                    child: GradientCenterTextButton(
                      buttonText: AppLocalizations.of(context)!
                          .translate('create_a_new_Playlist'),
                      listOfGradient: [
                        HexColor("#DF23E1"),
                        HexColor("#3820B2"),
                        HexColor("#39BCE9"),
                      ],
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.grey.shade900,
                              title: Text(
                                AppLocalizations.of(context)!
                                    .translate("give_your_collection_name")!,
                                // 'give_your_collection_name',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              content: TextField(
                                controller: con,
                                cursorColor: Colors.lightGreen,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                                maxLines: 3,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.lightGreen,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("cancel")!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    createPlaylists(playlistName: con.text);
                                  },
                                  child: BlocBuilder<CreatePlaylistsCubit,
                                      CreatePlaylistsState>(
                                    builder: (context, state) {
                                      return state is CreatePlaylistsLoading
                                          ? const LoadingIndicator()
                                          : Text(
                                              AppLocalizations.of(context)!
                                                  .translate(
                                                "create_a_new_Playlist",
                                              )!,
                                              style: TextStyle(
                                                color: Colors.lightGreen[700],
                                                fontSize: 15,
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
                child: Text(
                  AppLocalizations.of(context)!.translate("your_playlist")!,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 18,
                      ),
                ),
              ),
              BlocBuilder<MyPlaylistsCubit, MyPlaylistsState>(
                builder: (context, state) {
                  if (state is MyPlaylistsIsLoading && state.isFirstFetch) {
                    return const Center(child: LoadingIndicator());
                  }
                  if (state is MyPlaylistsIsLoading) {
                    BlocProvider.of<MyPlaylistsCubit>(context).loadMore = true;
                  } else if (state is MyPlaylistsError) {
                    return error_widget.ErrorWidget(
                      // onRetryPressed: () => _getAllMyPlaylists(),
                      msg: state.message!,
                    );
                  }

                  return BlocProvider.of<MyPlaylistsCubit>(context)
                          .songsMyPlaylists
                          .isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            controller: scrollController,
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount:
                                BlocProvider.of<MyPlaylistsCubit>(context)
                                        .songsMyPlaylists
                                        .length +
                                    (BlocProvider.of<MyPlaylistsCubit>(context)
                                            .loadMore
                                        ? 1
                                        : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  BlocProvider.of<MyPlaylistsCubit>(context)
                                      .songsMyPlaylists
                                      .length) {
                                final playList =
                                    BlocProvider.of<MyPlaylistsCubit>(
                                  context,
                                ).songsMyPlaylists[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.all(4),
                                  onTap: () async {
                                    addtoPlaylists(
                                      mediaId: widget.song!.id!,
                                      playListsId: playList.id!,
                                    );
                                    Constants.showToast(
                                      message: "Song added to playlist.",
                                    );
                                    Navigator.pop(context);
                                    Navigator.of(context).pop();
                                  },
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageUrl: playList.artworkUrl!,
                                      width: 50,
                                      height: 50,
                                      maxHeightDiskCache: 80,
                                      maxWidthDiskCache: 80,
                                      memCacheHeight: (80 *
                                              MediaQuery.of(context)
                                                  .devicePixelRatio)
                                          .round(),
                                      memCacheWidth: (80 *
                                              MediaQuery.of(context)
                                                  .devicePixelRatio)
                                          .round(),
                                      placeholder: (context, u) =>
                                          const LoadingImage(
                                        icon: Icon(Icons.verified_user),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    playList.title!,
                                    style: styleW700(context, fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    "Created By you ",
                                    //  +
                                    //     "".displayTimeAgoFromTimestamp(Myplaylists['created']),
                                    style: styleW400(context, fontSize: 12),
                                  ),
                                );
                              } else if (BlocProvider.of<MyPlaylistsCubit>(
                                    context,
                                  ).pageNo <=
                                  BlocProvider.of<MyPlaylistsCubit>(context)
                                      .totalPages) {
                                Timer(const Duration(milliseconds: 30), () {
                                  scrollController.jumpTo(
                                    scrollController.position.maxScrollExtent,
                                  );
                                });

                                return const LoadingIndicator();
                              }
                              return const SizedBox();
                            },
                          ),
                        )
                      : Padding(
                        padding: const EdgeInsets.only(top: 139),
                        child: const Center(
                            child: NoData(),
                          ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
