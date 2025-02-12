import 'dart:async';

import 'package:alamoody/core/utils/back_arrow.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/artist_details.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../../core/utils/no_data.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/cubits/artists/artists_cubit.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  ScrollController scrollController = ScrollController();

  getGetArtists() {
    BlocProvider.of<ArtistsCubit>(context).getArtists(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<ArtistsCubit>(context).pageNo <=
                BlocProvider.of<ArtistsCubit>(context).totalPages) {
          getGetArtists();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<ArtistsCubit>(context).clearData();

    getGetArtists();

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
                      AppLocalizations.of(context)!.translate("artists")!,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<ArtistsCubit, ArtistsState>(
                  builder: (context, state) {
                    if (state is ArtistsIsLoading && state.isFirstFetch) {
                      return const Expanded(child: LoadingScreen());
                    }
                    if (state is ArtistsIsLoading) {
                      BlocProvider.of<ArtistsCubit>(context).loadMore = true;
                    } else if (state is ArtistsError) {
                      return error_widget.ErrorWidget(
                        onRetryPressed: () => getGetArtists(),
                        msg: state.message!,
                      );
                    }

                    return BlocProvider.of<ArtistsCubit>(context)
                            .artists
                            .isNotEmpty
                        ? ListView.separated(
                            controller: scrollController,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: AppPadding.p20,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount: BlocProvider.of<ArtistsCubit>(context)
                                    .artists
                                    .length +
                                (BlocProvider.of<ArtistsCubit>(context).loadMore
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  BlocProvider.of<ArtistsCubit>(context)
                                      .artists
                                      .length) {
                                return GestureDetector(
                                  onTap: () {
                                    pushNavigate(
                                      context,
                                      ArtistDetails(
                                        artist: BlocProvider.of<ArtistsCubit>(
                                          context,
                                        ).artists[index],

                                        // user:artists,
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
                                          height: context.height * 0.110,
                                          width: 75,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                BlocProvider.of<ArtistsCubit>(
                                                  context,
                                                ).artists[index].artworkUrl!,
                                              ),
                                            ),
                                          ),
                                          // child:Image.asset(ImagesPath.singerImage ,fit: BoxFit.cover,)
                                          //  const CircleAvatar(
                                          //   // radius: 25,
                                          //   backgroundImage: AssetImage(
                                          //     ImagesPath.singerImage,
                                          //   ),
                                          // ),
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
                                                  BlocProvider.of<ArtistsCubit>(
                                                    context,
                                                  ).artists[index].name!,
                                                  style: styleW700(
                                                    context,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("artists")!,
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
                              } else if (BlocProvider.of<ArtistsCubit>(
                                    context,
                                  ).pageNo <=
                                  BlocProvider.of<ArtistsCubit>(context)
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



           