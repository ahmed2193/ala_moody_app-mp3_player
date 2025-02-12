import 'dart:async';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/components/reused_background.dart';
import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/loading_indicator.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alamoody/features/occasions/presentation/cubits/occasions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../../core/utils/error_widget.dart' as error_widget;

class OccasionsScreen extends StatefulWidget {
  const OccasionsScreen({
    required this.id,
    required this.txt,
    required this.headerName,
    Key? key,
  }) : super(key: key);
  final int id;
  final String headerName;
  final String txt;
  @override
  State<OccasionsScreen> createState() => _OccasionsScreenState();
}

class _OccasionsScreenState extends State<OccasionsScreen> {
  ScrollController scrollController = ScrollController();

  getOccasions() {
    BlocProvider.of<OccasionsCubit>(context).getOccasions(
      txt: widget.txt,
      id: widget.id.toString(),
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<OccasionsCubit>(context).pageNo <=
                BlocProvider.of<OccasionsCubit>(context).totalPages) {
          getOccasions();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<OccasionsCubit>(context).clearData();

    getOccasions();

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
                      AppLocalizations.of(context)!
                          .translate(widget.headerName)!??'',
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<OccasionsCubit, OccasionsState>(
                  builder: (context, state) {
                    if (state is OccasionsIsLoading && state.isFirstFetch) {
                      return const Expanded(child: LoadingScreen());
                    }
                    if (state is OccasionsIsLoading) {
                      BlocProvider.of<OccasionsCubit>(context).loadMore = true;
                    } else if (state is OccasionsError) {
                      return error_widget.ErrorWidget(
                        onRetryPressed: () => getOccasions(),
                        msg: state.message!,
                      );
                    }

                    return BlocProvider.of<OccasionsCubit>(context)
                            .occasions
                            .isNotEmpty
                        ? ListView.separated(
                            controller: scrollController,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: AppPadding.p20,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount: BlocProvider.of<OccasionsCubit>(context)
                                    .occasions
                                    .length +
                                (BlocProvider.of<OccasionsCubit>(context)
                                        .loadMore
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  BlocProvider.of<OccasionsCubit>(context)
                                      .occasions
                                      .length) {
                                return
                                    //  FeaturedListSlider(
                                    //   con: con,
                                    //   index: index,
                                    //   OccasionsCubit:
                                    //       BlocProvider.of<OccasionsCubit>(context)
                                    //           .OccasionsCubit[index],
                                    // );
                                    Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      final con = Provider.of<MainController>(
                                          context,
                                          listen: false,);
                                      final items =
                                          BlocProvider.of<OccasionsCubit>(
                                        context,
                                      ).occasions;
 con.playSong(
                                        con.convertToAudio(items),
                                        items.indexOf(items[index]),
                                      );
                                    },
                                    child: SongItem(
                                      menuItem: MenuItemButtonWidget(
                                        song: BlocProvider.of<OccasionsCubit>(
                                          context,
                                        ).occasions[index],
                                      ),
                                      songs: BlocProvider.of<OccasionsCubit>(
                                        context,
                                      ).occasions[index],
                                    ),
                                  ),
                                );
                              } else if (BlocProvider.of<OccasionsCubit>(
                                    context,
                                  ).pageNo <=
                                  BlocProvider.of<OccasionsCubit>(context)
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
