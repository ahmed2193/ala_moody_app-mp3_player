import 'dart:async';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/entities/songs.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/no_data.dart';
import '../../../../core/utils/song_item.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../cubits/add_and_remove_from_favorite/add_and_remove_from_favorite_cubit.dart';
import '../cubits/getFavorite/get_favorite_cubit.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  ScrollController scrollController = ScrollController();

  getGetFavorite() {
    BlocProvider.of<GetFavoriteCubit>(context).getFavorite(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<GetFavoriteCubit>(context).pageNo <=
                BlocProvider.of<GetFavoriteCubit>(context).totalPages) {
          getGetFavorite();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<GetFavoriteCubit>(context).clearData();

    getGetFavorite();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        // key: scaffoldKey,
        // drawer: const DrawerScreen(),
        body: ReusedBackground(
          lightBG: ImagesPath.homeBGLightBG,
          body: BlocBuilder<GetFavoriteCubit, GetFavoriteState>(
            builder: (context, state) {
              if (state is GetFavoriteIsLoading && state.isFirstFetch) {
                return const LoadingScreen();
              }
              if (state is GetFavoriteIsLoading) {
                BlocProvider.of<GetFavoriteCubit>(context).loadMore = true;
              } else if (state is GetFavoriteError) {
                return error_widget.ErrorWidget(
                  // onRetryPressed: () => _getAllGetFavorite(),
                  msg: state.message!,
                );
              }

              return Column(
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
                          AppLocalizations.of(context)!.translate("favorites")!,
                          style: styleW600(context)!
                              .copyWith(fontSize: FontSize.f18),
                        ),
                      ),
                    ],
                  ),
                  if (BlocProvider.of<GetFavoriteCubit>(context)
                      .favorite
                      .isNotEmpty)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.pDefault,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsetsDirectional.only(
                            top: AppPadding.p20,
                            bottom: AppPadding.p20 * 8,
                          ),
                          physics: const BouncingScrollPhysics(),
                          controller: scrollController,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: AppPadding.p20,
                          ),
                          itemCount: BlocProvider.of<GetFavoriteCubit>(context)
                                  .favorite
                                  .length +
                              (BlocProvider.of<GetFavoriteCubit>(context)
                                      .loadMore
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index <
                                BlocProvider.of<GetFavoriteCubit>(context)
                                    .favorite
                                    .length) {
                              return FavoriteItem(
                                index: index,
                                songs:
                                    BlocProvider.of<GetFavoriteCubit>(context)
                                        .favorite[index],
                                songList:
                                    BlocProvider.of<GetFavoriteCubit>(context)
                                        .favorite,
                              );
                            } else if (BlocProvider.of<GetFavoriteCubit>(
                                  context,
                                ).pageNo <=
                                BlocProvider.of<GetFavoriteCubit>(context)
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
                      ),
                    )
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 150),
                        child: NoData(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({
    required this.songs,
    required this.index,
    required this.songList,
    Key? key,
  }) : super(key: key);
  final Songs songs;
  final List<Songs> songList;

  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddAndRemoveFromFavoritesCubit,
        AddAndRemoveFromFavoritesState>(
      listener: (context, state) {
//if

        if (state is AddAndRemoveFromFavoritesSuccess) {
          BlocProvider.of<GetFavoriteCubit>(context).getFavorite(
            accessToken:
                context.read<LoginCubit>().authenticatedUser!.accessToken,
          );
        }
        if (state is AddAndRemoveFromFavoritesLoading) {
          if (state.id == songs.id) {
            BlocProvider.of<GetFavoriteCubit>(context).favorite.removeAt(index);
          }
        }
      },
      builder: (context, state) {
        return SongItem(
          songs: songs,
          menuItem: PopupMenuButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            icon: SvgPicture.asset(
              ImagesPath.menuItemIcon,
              color: Theme.of(context).iconTheme.color,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.play_arrow),
                      Text(
                        AppLocalizations.of(context)!.translate("play")!,
                        style: styleW700(context, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // PopupMenuItem(
                //   value: 2,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const Icon(Icons.share),
                //       Text(
                //         AppLocalizations.of(context)!.translate("share")!,
                //         style: styleW700(context, fontSize: 14),
                //       ),
                //     ],
                //   ),
                // ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.delete),
                      Text(
                        AppLocalizations.of(context)!.translate("delete")!,
                        style: styleW700(context, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 2) {
                // _deleteInfo(index);
                BlocProvider.of<AddAndRemoveFromFavoritesCubit>(context)
                    .addAndRemoveFromFavorites(
                  accessToken: context
                      .read<LoginCubit>()
                      .authenticatedUser!
                      .accessToken!,
                  favtype: BlocProvider.of<AddAndRemoveFromFavoritesCubit>(
                    context,
                  ).type = 0,
                  id: songs.id!,
                );
              }
              if (value == 1) {
                final con = Provider.of<MainController>(context, listen: false);
                con.playSong(
                  con.convertToAudio(songList),
                  songList.indexOf(songs),
                );
                print('You Click on po up menu item$value');
              }
              // if (value == 2) {
              //   // await Share.share(
              //   //     "${personData.title} \n ${personData.audiosUrl}");
              //   Share.share(
              //     '${ songs.artists![0].name!} - ${songs.title }  \n ${songs.streamUrl!}  ',
              //     subject: songs.title,
              //   );
              // }
            },
          ),
        );
      },
    );
  }
}
