import 'dart:async';

import 'package:alamoody/core/utils/back_arrow.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/no_data.dart';
import '../../../../core/utils/song_item.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/cubits/popular_songs/popular_songs_cubit.dart';

class MostPopularScreen extends StatefulWidget {
  const MostPopularScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MostPopularScreen> createState() => _MostPopularScreenState();
}

class _MostPopularScreenState extends State<MostPopularScreen> {
  ScrollController scrollController = ScrollController();

  getGetMostPopular() {
    BlocProvider.of<PopularSongsCubit>(context).getPopularSongs(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<PopularSongsCubit>(context).pageNo <=
                BlocProvider.of<PopularSongsCubit>(context).totalPages) {
          getGetMostPopular();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<PopularSongsCubit>(context).clearData();

    getGetMostPopular();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    return SafeArea(
      child: Scaffold(
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
                      AppLocalizations.of(context)!.translate('most_popular')!,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<PopularSongsCubit, PopularSongsState>(
                  builder: (context, state) {
                    if (state is PopularSongsIsLoading && state.isFirstFetch) {
                      return const Expanded(child: LoadingScreen());
                    }
                    if (state is PopularSongsIsLoading) {
                      BlocProvider.of<PopularSongsCubit>(context).loadMore =
                          true;
                    } else if (state is PopularSongsError) {
                      return error_widget.ErrorWidget(
                        onRetryPressed: () => getGetMostPopular(),
                        msg: state.message!,
                      );
                    }

                    return BlocProvider.of<PopularSongsCubit>(context)
                            .popularSongs
                            .isNotEmpty
                        ? ListView.separated(
                            controller: scrollController,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: AppPadding.p20,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding:  EdgeInsets.only(bottom: context.height * 0.129,),
                            itemCount:
                                BlocProvider.of<PopularSongsCubit>(context)
                                        .popularSongs
                                        .length +
                                    (BlocProvider.of<PopularSongsCubit>(context)
                                            .loadMore
                                        ? 1
                                        : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  BlocProvider.of<PopularSongsCubit>(context)
                                      .popularSongs
                                      .length) {
                                return
                                    //  FeaturedListSlider(
                                    //   con: con,
                                    //   index: index,
                                    //   popularSongs:
                                    //       BlocProvider.of<PopularSongsCubit>(context)
                                    //           .popularSongs[index],
                                    // );
                                    Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      final con = Provider.of<MainController>(
                                          context,
                                          listen: false,);
                                      final items =
                                          BlocProvider.of<PopularSongsCubit>(
                                        context,
                                      ).popularSongs;
                                      con.playSong(
                                        con.convertToAudio(items),
                                        items.indexOf(items[index]),
                                      );
                                    },
                                    child: SongItem(
                                      menuItem: MenuItemButtonWidget(
                                        song:
                                            BlocProvider.of<PopularSongsCubit>(
                                          context,
                                        ).popularSongs[index],
                                      ),
                                      songs: BlocProvider.of<PopularSongsCubit>(
                                        context,
                                      ).popularSongs[index],
                                    ),
                                  ),
                                );
                              } else if (BlocProvider.of<PopularSongsCubit>(
                                    context,
                                  ).pageNo <=
                                  BlocProvider.of<PopularSongsCubit>(context)
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
                          )
                        : const Center(
                            child: NoData(),
                          );
                  },
                ),
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}
