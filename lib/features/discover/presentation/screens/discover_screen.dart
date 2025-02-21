import 'dart:async';

import 'package:alamoody/core/utils/back_arrow.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:alamoody/features/discover/presentation/cubits/library/discover_cubit.dart';
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

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  ScrollController scrollController = ScrollController();

  getGetDiscover() {
    BlocProvider.of<DiscoverCubit>(context).getDiscover(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<DiscoverCubit>(context).pageNo <=
                BlocProvider.of<DiscoverCubit>(context).totalPages) {
          getGetDiscover();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<DiscoverCubit>(context).clearData();

    getGetDiscover();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    return Scaffold(
      
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
                    AppLocalizations.of(context)!.translate('discover')!,
                    style:
                        styleW600(context)!.copyWith(fontSize: FontSize.f18),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<DiscoverCubit, DiscoverState>(
                builder: (context, state) {
                  if (state is DiscoverIsLoading && state.isFirstFetch) {
                    return const Expanded(child: LoadingScreen());
                  }
                  if (state is DiscoverIsLoading) {
                    BlocProvider.of<DiscoverCubit>(context).loadMore = true;
                  } else if (state is DiscoverError) {
                    return error_widget.ErrorWidget(
                      onRetryPressed: () => getGetDiscover(),
                      msg: state.message!,
                    );
                  }
    
                  return BlocProvider.of<DiscoverCubit>(context)
                          .discoverData
                          .isNotEmpty
                      ? ListView.separated(
                          controller: scrollController,
                          separatorBuilder: (context, index) =>
                              const SizedBox(
                            width: AppPadding.p20,
                          ),
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 110),
                          itemCount: BlocProvider.of<DiscoverCubit>(context)
                                  .discoverData
                                  .length +
                              (BlocProvider.of<DiscoverCubit>(context)
                                      .loadMore
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index <
                                BlocProvider.of<DiscoverCubit>(context)
                                    .discoverData
                                    .length) {
                              return
                            
                                  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    final con = Provider.of<MainController>(
                                        context,
                                        listen: false,);
                                    con.playSong(
                                      con.convertToAudio(
                                          BlocProvider.of<DiscoverCubit>(
                                        context,
                                      ).discoverData,),
                                      BlocProvider.of<DiscoverCubit>(
                                        context,
                                      ).discoverData.indexOf(
                                              BlocProvider.of<DiscoverCubit>(
                                            context,
                                          ).discoverData[index],),
                                    );
    
                                  },
                                  child: SongItem(
                                    menuItem: MenuItemButtonWidget(
                                      song: BlocProvider.of<DiscoverCubit>(
                                        context,
                                      ).discoverData[index],
                                    ),
                                    songs: BlocProvider.of<DiscoverCubit>(
                                      context,
                                    ).discoverData[index],
                                  ),
                                ),
                              );
                            } else if (BlocProvider.of<DiscoverCubit>(
                                  context,
                                ).pageNo <=
                                BlocProvider.of<DiscoverCubit>(context)
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
    );
  }
}
        