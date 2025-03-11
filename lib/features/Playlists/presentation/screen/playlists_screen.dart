import 'dart:async';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

// //import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../../core/utils/no_data.dart';
import '../../../audio_playlists/presentation/screen/audio_playlists_screen.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/cubits/play_lists/play_lists_cubit.dart';

class PlayListsScreen extends StatefulWidget {
  const PlayListsScreen({
    Key? key,

  }) : super(key: key);
  @override
  State<PlayListsScreen> createState() => _PlayListsScreenState();
}

class _PlayListsScreenState extends State<PlayListsScreen> {
  ScrollController scrollController = ScrollController();

  getGetPlayLists() {
    BlocProvider.of<PlayListsCubit>(context).getPlayLists(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  @override
  void initState() {
    BlocProvider.of<PlayListsCubit>(context).clearData();

    getGetPlayLists();

    // _setupScrollControllerSongs(context);

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
                      AppLocalizations.of(context)!.translate("Play_lists")!,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
           Expanded(
                child: BlocBuilder<PlayListsCubit, PlayListsState>(
                  builder: (context, state) {
                    if (state is PlayListsIsLoading && state.isFirstFetch) {
                      return const Center(child: LoadingScreen());
                    }
                    if (state is PlayListsIsLoading) {
                      BlocProvider.of<PlayListsCubit>(context).loadMore = true;
                    } else if (state is PlayListsError) {
                      return error_widget.ErrorWidget(
                        // onRetryPressed: () => _getAllPlayLists(),
                        msg: state.message!,
                      );
                    }
                
                    return BlocProvider.of<PlayListsCubit>(context)
                            .songsPlayLists
                            .isNotEmpty
                        ? ListView.separated(
                          controller: scrollController,
                          separatorBuilder: (context, index) =>
                              const SizedBox(
                            width: AppPadding.p20,
                          ),
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: BlocProvider.of<PlayListsCubit>(context)
                                  .songsPlayLists
                                  .length +
                              (BlocProvider.of<PlayListsCubit>(context)
                                      .loadMore
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index <
                                BlocProvider.of<PlayListsCubit>(context)
                                    .songsPlayLists
                                    .length) {
                              return
                              
                                  GestureDetector(
                                onTap: () {
                                  pushNavigate(
                                    context,
                                    AudioPlayListsScreen(
                                      songsPlayLists:
                                          BlocProvider.of<PlayListsCubit>(
                                        context,
                                      ).songsPlayLists[index],
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
                                              BlocProvider.of<PlayListsCubit>(
                                                context,
                                              )
                                                  .songsPlayLists[index]
                                                  .artworkUrl!,
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
                                                BlocProvider.of<
                                                        PlayListsCubit>(
                                                  context,
                                                )
                                                    .songsPlayLists[index]
                                                    .title!,
                                                style: styleW700(
                                                  context,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              if (BlocProvider.of<PlayListsCubit>(
                                                context,
                                              )
                                                      .songsPlayLists[index]
                                                      .description!
                                                      .isEmpty) const SizedBox() else Text(
                                                      BlocProvider.of<
                                                              PlayListsCubit>(
                                                        context,
                                                      )
                                                          .songsPlayLists[
                                                              index]
                                                          .description!,
                                                      style: styleW400(
                                                        context,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                              Text(
                                                "by ${BlocProvider.of<PlayListsCubit>(context).songsPlayLists[index].user!.username!}",
                                                style: styleW400(
                                                  context,
                                                  fontSize: 12,
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
                            } else if (BlocProvider.of<PlayListsCubit>(
                                  context,
                                ).pageNo <=
                                BlocProvider.of<PlayListsCubit>(context)
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
