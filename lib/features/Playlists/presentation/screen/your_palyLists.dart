import 'dart:async';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/my_playlists/my_playlists_cubit.dart';
import 'package:alamoody/features/audio_playlists/presentation/screen/audio_playlists_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../../core/utils/no_data.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';

class MyPlaylistsScreen extends StatefulWidget {
  const MyPlaylistsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyPlaylistsScreen> createState() => _MyPlaylistsScreenState();
}

class _MyPlaylistsScreenState extends State<MyPlaylistsScreen> {
  ScrollController scrollController = ScrollController();

  getGetMyPlaylists() {
    BlocProvider.of<MyPlaylistsCubit>(context).getMyPlaylists(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<MyPlaylistsCubit>(context).pageNo <=
                BlocProvider.of<MyPlaylistsCubit>(context).totalPages) {
          getGetMyPlaylists();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<MyPlaylistsCubit>(context).clearData();

    getGetMyPlaylists();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

    final double logicalSize = 180 / devicePexelRatio;
    return SafeArea(
      child: Scaffold(
        // key: scaffoldKey,
        // drawer: const DrawerScreen(),
        body: ReusedBackground(
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
                      AppLocalizations.of(context)!.translate("your_playlist")!,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
              BlocBuilder<MyPlaylistsCubit, MyPlaylistsState>(
                builder: (context, state) {
                  if (state is MyPlaylistsIsLoading && state.isFirstFetch) {
                    return const Expanded(
                      child: Center(child: LoadingScreen()),
                    );
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
                      ? Expanded(
                          child: ListView.separated(
                            controller: scrollController,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: AppPadding.p20,
                            ),
                            // physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 100),
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
                                return
                                    //  FeaturedListSlider(
                                    //   con: con,
                                    //   index: index,
                                    //   songsMyPlaylists:
                                    //       BlocProvider.of<MyPlaylistsCubit>(context)
                                    //           .songsMyPlaylists[index],
                                    // );
                                    GestureDetector(
                                  onTap: () {
                                    pushNavigate(
                                      context,
                                      AudioPlayListsScreen(
                                        ispublic: true,
                                        songsPlayLists:
                                            BlocProvider.of<MyPlaylistsCubit>(
                                          context,
                                        ).songsMyPlaylists[index],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: GradientBoxBorder(
                                        gradient: LinearGradient(
                                          colors: [
                                            HexColor("#020024"),
                                            HexColor("#090979"),
                                            Colors.black26,
                                          ],
                                        ),
                                        width: 2.4,
                                      ),
                                      gradient: const LinearGradient(
                                        end: Alignment(1, 2),
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.transparent,
                                          // HexColor("#020024"),
                                          // HexColor("#090979"),
                                          // Colors.black26,
                                        ],
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: logicalSize,
                                          width: logicalSize,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: BlocProvider.of<
                                                          MyPlaylistsCubit>(
                                                    context,
                                                  )
                                                      .songsMyPlaylists[index]
                                                      .artworkUrl ??
                                                  '',
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ), // Loading indicator
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                ImagesPath
                                                    .playlistDefultImage, // Fallback image
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  BlocProvider.of<
                                                          MyPlaylistsCubit>(
                                                    context,
                                                  )
                                                      .songsMyPlaylists[index]
                                                      .title!,
                                                  style: styleW700(
                                                    context,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  "by ${BlocProvider.of<MyPlaylistsCubit>(context).songsMyPlaylists[index].user!.username!}",
                                                  style: styleW400(
                                                    context,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                      : const Expanded(
                          child: Center(child: NoData()),
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
// Expanded(
//         child: ListView.separated(
//           shrinkWrap: true,
//           padding: const EdgeInsetsDirectional.only(
//             top: AppPadding.p20,
//             bottom: AppPadding.p20 * 6,
//           ),
//           physics: const AlwaysScrollableScrollPhysics(),
//           controller: scrollController,
//           separatorBuilder: (context, index) => const SizedBox(
//             height: AppPadding.p20,
//           ),
//           itemCount: 10,
//           itemBuilder: (context, index) {
//             return
//           },
//         ),
//       ),
