import 'dart:async';
import 'dart:developer';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/core/utils/song_item.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/images.dart';
import '../config/locale/app_localizations.dart';
import '../config/themes/colors.dart';
import '../features/audio_playlists/presentation/cubit/audio_playlists_cubit.dart';
import '../features/audio_playlists/presentation/screen/loading.dart';
import '../features/auth/presentation/cubit/login/login_cubit.dart';
import '../features/home/presentation/cubits/artist_details/artist_details_cubit.dart';
import '../features/home/presentation/cubits/follow_and_unfollow/follow_and_unfollow_cubit.dart';
import 'components/screen_state/loading_screen.dart';
import 'entities/artists.dart';
import 'helper/font_style.dart';
import 'utils/loading_indicator.dart';
import 'utils/sliver_appbar.dart';

class ArtistDetails extends StatefulWidget {
  final Artists artist;
  const ArtistDetails({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistDetails> createState() => _ArtistDetailsState();
}

class _ArtistDetailsState extends State<ArtistDetails> {
  ScrollController scrollController = ScrollController();

  Future<void> _getArtists() =>
      BlocProvider.of<ArtistDetailsCubit>(context).artistDetails(
        id: widget.artist.id!,
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );
  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<ArtistDetailsCubit>(context).pageNo <=
                BlocProvider.of<ArtistDetailsCubit>(context).totalPages) {
          _getArtists();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<ArtistDetailsCubit>(context).clearData();

    _getArtists();
    _setupScrollControllerSongs(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBody: true,
        body: ReusedBackground(
          lightBG: ImagesPath.homeBGLightBG,
          body: BlocBuilder<ArtistDetailsCubit, ArtistDetailsState>(
            builder: (context, state) {
              if (state is ArtistDetailsLoading && state.isFirstFetch) {
                return const LoadingScreen();
              }
              if (state is ArtistDetailsLoading) {
                BlocProvider.of<ArtistDetailsCubit>(context).loadMore = true;
              } else if (state is ArtistDetailsError) {
                return error_widget.ErrorWidget(
                  onRetryPressed: () => _getArtists(),
                  msg: state.message,
                );
              }

              final songs = BlocProvider.of<ArtistDetailsCubit>(context).songs;
              printColored(songs);
              return songs.isNotEmpty
                  ? CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverPersistentHeader(
                          delegate: MyDelegate(
                            user: widget.artist,
                            songs: songs,
                          ),
                          pinned: true,
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<AudioPlayListsCubit>(
                                      context,
                                    ).playSongs(context, 0, songs);
                                  },
                                  child: Container(
                                    width: 150,
                                    decoration: const BoxDecoration(
                                      color: AppColors.cPrimary,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("play")!,
                                        style: styleW400(
                                          context,
                                          fontSize: 16,
                                          color: AppColors.cOffWhite,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                FollowButton(artist: widget.artist),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) {
                              if (i <
                                  BlocProvider.of<ArtistDetailsCubit>(context)
                                      .songs
                                      .length) {
                                return Builder(
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<AudioPlayListsCubit>(
                                          context,
                                        ).playSongs(context, i, songs);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    (i + 1).toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Theme.of(context)
                                                          .listTileTheme
                                                          .iconColor,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      3,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      errorWidget: (
                                                        context,
                                                        url,
                                                        error,
                                                      ) =>
                                                          const Icon(
                                                        Icons.error,
                                                      ),
                                                      imageUrl:
                                                          songs[i].artworkUrl!,
                                                      width: 50,
                                                      height: 50,
                                                      maxHeightDiskCache: 100,
                                                      maxWidthDiskCache: 100,
                                                      memCacheHeight: (50 *
                                                              MediaQuery.of(
                                                                context,
                                                              ).devicePixelRatio)
                                                          .round(),
                                                      memCacheWidth: (50 *
                                                              MediaQuery.of(
                                                                context,
                                                              ).devicePixelRatio)
                                                          .round(),
                                                      progressIndicatorBuilder:
                                                          (context, url, l) =>
                                                              const LoadingImage(),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  AudioWave(
                                                    song: songs[i],
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            songs[i].title!,
                                                            maxLines: 1,
                                                            style: styleW400(
                                                              context,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            songs[i]
                                                                .duration
                                                                .toString(),
                                                            style: styleW400(
                                                              context,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            MenuItemButtonWidget(
                                              song: songs[i],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (BlocProvider.of<ArtistDetailsCubit>(
                                    context,
                                  ).pageNo <=
                                  BlocProvider.of<ArtistDetailsCubit>(context)
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
                            childCount: BlocProvider.of<ArtistDetailsCubit>(
                                  context,
                                ).songs.length +
                                (BlocProvider.of<ArtistDetailsCubit>(context)
                                        .loadMore
                                    ? 1
                                    : 0),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 150),
                        ),
                      ],
                    )
                  : const Center(
                      child: NoData(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class FollowButton extends StatelessWidget {
  const FollowButton({
    required this.artist,
    Key? key,
  }) : super(key: key);
  final Artists artist;
  @override
  Widget build(BuildContext context) {
    printColored("${artist.favorite.toString()*100}");
    bool isfollow = artist.favorite ?? false;
    log(artist.favorite.toString());
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return BlocConsumer<FollowAndUnFollowCubit, FollowAndUnFollowState>(
          listener: (context, state) {
            if (state is FollowAndUnFollowLoading) {
              setState(() {
                isfollow = !isfollow;
                artist.favorite = isfollow;
              });
            }

            if (state is FollowAndUnFollowFailed) {
              setState(() {
                isfollow = !isfollow;
                artist.favorite = isfollow;
              });
            }
            if (state is FollowAndUnFollowSuccess) {
              setState(() {
                artist.favorite = isfollow;
              });
              // BlocProvider.of<ArtistsCubit>(context).getArtists(
              //   accessToken:
              //       context.read<LoginCubit>().authenticatedUser!.accessToken,
              // );
            }
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<FollowAndUnFollowCubit>(context)
                    .followAndUnFollow(
                  id: artist.id!,
                  accessToken: context
                      .read<LoginCubit>()
                      .authenticatedUser!
                      .accessToken!,
                  favtype: !isfollow
                      ? BlocProvider.of<FollowAndUnFollowCubit>(
                          context,
                        ).type = 1
                      : BlocProvider.of<FollowAndUnFollowCubit>(
                          context,
                        ).type = 0,
                );
              },
              child: Container(
                width: context.height * 0.22,
                decoration: const BoxDecoration(
                  color: AppColors.cPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    isfollow
                        ? AppLocalizations.of(context)!.translate("following")!
                        : AppLocalizations.of(context)!.translate("follow")!,
                    style: styleW400(
                      context,
                      fontSize: 16,
                      color: AppColors.cOffWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
