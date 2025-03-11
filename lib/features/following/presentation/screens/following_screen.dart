import 'dart:async';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/artist_details.dart';
import 'package:alamoody/core/components/reused_background.dart';
import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/hex_color.dart';
import 'package:alamoody/core/utils/loading_indicator.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alamoody/features/home/presentation/widgets/icon_button_reuse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../../core/utils/error_widget.dart' as error_widget;
import '../cubits/following_cubit.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  ScrollController scrollController = ScrollController();

  getGetFollowing() {
    BlocProvider.of<FollowingCubit>(context).getFollowing(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<FollowingCubit>(context).pageNo <=
                BlocProvider.of<FollowingCubit>(context).totalPages) {
          getGetFollowing();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<FollowingCubit>(context).clearData();

    getGetFollowing();

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
                      AppLocalizations.of(context)!.translate('following')!,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<FollowingCubit, FollowingState>(
                  builder: (context, state) {
                    if (state is FollowingIsLoading && state.isFirstFetch) {
                      return const Center(child: LoadingScreen());
                    }
                    if (state is FollowingIsLoading) {
                      BlocProvider.of<FollowingCubit>(context).loadMore = true;
                    } else if (state is FollowingError) {
                      return error_widget.ErrorWidget(
                        onRetryPressed: () => getGetFollowing(),
                        msg: state.message!,
                      );
                    }

                    return BlocProvider.of<FollowingCubit>(context)
                            .following
                            .isNotEmpty
                        ? ListView.separated(
                            controller: scrollController,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: AppPadding.p20,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount: BlocProvider.of<FollowingCubit>(context)
                                    .following
                                    .length +
                                (BlocProvider.of<FollowingCubit>(context)
                                        .loadMore
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  BlocProvider.of<FollowingCubit>(context)
                                      .following
                                      .length) {
                                return
                                    //  FeaturedListSlider(
                                    //   con: con,
                                    //   index: index,
                                    //   FollowingCubit:
                                    //       BlocProvider.of<FollowingCubit>(context)
                                    //           .followingCubit[index],
                                    // );
                                    Container(
                                  margin: const EdgeInsets.all(12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // user pic
                                      const SizedBox(width: AppPadding.p10),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          padding: const EdgeInsets.all(
                                            AppPadding.p10,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: GradientBoxBorder(
                                              gradient: LinearGradient(
                                                colors: [
                                                  HexColor("#A866AE"),
                                                  HexColor("#37C3EE"),
                                                ],
                                              ),
                                              width: 2,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                HexColor("#1818B7"),
                                                HexColor("#AE39A0"),
                                              ],
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                BlocProvider.of<FollowingCubit>(
                                                  context,
                                                ).following[index].artworkUrl!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        // const CircleContainerWithGradientBorder(
                                        //   isMusic: false,
                                        //   width: 60,
                                        //   image: ImagesPath.singerImage,
                                        // ),
                                      ),
                                      const SizedBox(width: AppPadding.p10),
                                      // user name and mail'
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              BlocProvider.of<FollowingCubit>(
                                                context,
                                              ).following[index].name!,
                                              style: styleW600(context),
                                            ),
                                            //TODO ADDED EMAIL
                                            // Text(
                                            //   'Gamal',
                                            //   style: styleW600(
                                            //     context,
                                            //     fontSize: FontSize.f10,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      ReusedIconButton(
                                        onPressed: () {
                                          pushNavigate(
                                            context,
                                            ArtistDetails(
                                              artistId: BlocProvider.of<
                                                      FollowingCubit>(context)
                                                  .following[index].id.toString(),

                                              // user:artists,
                                            ),
                                          );
                                        },
                                        image: ImagesPath.forwardIconSvg,
                                        width: 12,
                                      ),
                                    ],
                                  ),
                                );
                              } else if (BlocProvider.of<FollowingCubit>(
                                    context,
                                  ).pageNo <=
                                  BlocProvider.of<FollowingCubit>(context)
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
           