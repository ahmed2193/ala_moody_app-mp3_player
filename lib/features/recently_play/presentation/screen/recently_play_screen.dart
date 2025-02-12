import 'dart:async';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/no_data.dart';
import '../../../../core/utils/song_item.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/cubits/recent_listen/recent_listen_cubit.dart';

class RecentlyPlayScreen extends StatefulWidget {
  const RecentlyPlayScreen({
    required this.headerTitle,
    Key? key,
  }) : super(key: key);
  final String headerTitle;

  @override
  State<RecentlyPlayScreen> createState() => _RecentlyPlayScreenState();
}

class _RecentlyPlayScreenState extends State<RecentlyPlayScreen> {
  ScrollController scrollController = ScrollController();

 void getGetRecentlyPlay() {
    BlocProvider.of<RecentListenCubit>(context).getrecentListen(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<RecentListenCubit>(context).pageNo <=
                BlocProvider.of<RecentListenCubit>(context).totalPages) {
          getGetRecentlyPlay();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<RecentListenCubit>(context).clearData();

    getGetRecentlyPlay();

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
                      widget.headerTitle,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<RecentListenCubit, RecentListenState>(
                  builder: (context, state) {
                    if (state is RecentListenIsLoading && state.isFirstFetch) {
                      return const Expanded(child: LoadingScreen());
                    }
                    if (state is RecentListenIsLoading) {
                      BlocProvider.of<RecentListenCubit>(context).loadMore =
                          true;
                    } else if (state is RecentListenError) {
                      return error_widget.ErrorWidget(
                        onRetryPressed: () => getGetRecentlyPlay(),
                        msg: state.message!,
                      );
                    }

                    return BlocProvider.of<RecentListenCubit>(context)
                            .recentListen
                            .isNotEmpty
                        ? ListView.separated(
                            controller: scrollController,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: AppPadding.p20,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount:
                                BlocProvider.of<RecentListenCubit>(context)
                                        .recentListen
                                        .length +
                                    (BlocProvider.of<RecentListenCubit>(context)
                                            .loadMore
                                        ? 1
                                        : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  BlocProvider.of<RecentListenCubit>(context)
                                      .recentListen
                                      .length) {
                                return
                                    //  FeaturedListSlider(
                                    //   con: con,
                                    //   index: index,
                                    //   RecentListenCubit:
                                    //       BlocProvider.of<RecentListenCubit>(context)
                                    //           .RecentListenCubit[index],
                                    // );
                                    Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      final con = Provider.of<MainController>(
                                          context,
                                          listen: false,);

                                      con.playSong(
                                        con.convertToAudio(
                                            BlocProvider.of<RecentListenCubit>(
                                          context,
                                        ).recentListen,),
                                        BlocProvider.of<RecentListenCubit>(
                                          context,
                                        ).recentListen.indexOf(BlocProvider.of<
                                                RecentListenCubit>(
                                              context,
                                            ).recentListen[index],),
                                      );
                                    },
                                    child: SongItem(
                                      menuItem: MenuItemButtonWidget(
                                        song:
                                            BlocProvider.of<RecentListenCubit>(
                                          context,
                                        ).recentListen[index],
                                      ),
                                      songs: BlocProvider.of<RecentListenCubit>(
                                        context,
                                      ).recentListen[index],
                                    ),
                                  ),
                                );
                              } else if (BlocProvider.of<RecentListenCubit>(
                                    context,
                                  ).pageNo <=
                                  BlocProvider.of<RecentListenCubit>(context)
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
              SizedBox(
                height: context.height * 0.129,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
           