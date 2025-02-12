import 'dart:async';

import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../config/locale/app_localizations.dart';
import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/helper/font_style.dart';
import '../../../../../../core/utils/controllers/main_controller.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../../../core/utils/loading_indicator.dart';
import '../../../../../home/presentation/cubits/recent_listen/recent_listen_cubit.dart';

class LastPlayedSection extends StatelessWidget {
  LastPlayedSection({
    Key? key,
    required this.scrollController,
    required this.onRetryPressed,
  }) : super(key: key);
  ScrollController scrollController = ScrollController();
  final VoidCallback onRetryPressed;
  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<RecentListenCubit, RecentListenState>(
      builder: (context, state) {
        if (state is RecentListenIsLoading && state.isFirstFetch) {
          return const LoadingIndicator();
        }
        if (state is RecentListenIsLoading) {
          BlocProvider.of<RecentListenCubit>(context).loadMore = true;
        } else if (state is RecentListenError) {
          return error_widget.ErrorWidget(
            onRetryPressed: onRetryPressed,
            msg: state.message!,
          );
        }

        return  Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.pDefault,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // last play text
                        Text(
                          AppLocalizations.of(context)!
                              .translate("last_played")!,
                          style: styleW600(context)!
                              .copyWith(fontSize: FontSize.f18),
                        ),
                        // all text
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Text(
                        //     "All",
                        //     // AppLocalizations.of(context)!.translate()!,
                        //     style: styleW500(context, fontSize: FontSize.f14),
                        //   ),
                        // ),
                      ],
                    ),
                BlocProvider.of<RecentListenCubit>(context)
                .recentListen
                .isNotEmpty
            ?    ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsetsDirectional.only(
                        top: AppPadding.p20,
                        bottom: AppPadding.p20 * 6,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      controller: scrollController,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: AppPadding.p20,
                      ),
                      itemCount: BlocProvider.of<RecentListenCubit>(context)
                              .recentListen
                              .length +
                          (BlocProvider.of<RecentListenCubit>(context).loadMore
                              ? 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (index <
                            BlocProvider.of<RecentListenCubit>(context)
                                .recentListen
                                .length) {
                          final songs =
                              BlocProvider.of<RecentListenCubit>(context)
                                  .recentListen;
                          final song = songs[index];

                          return GestureDetector(
                            onTap: () {
                              final con = Provider.of<MainController>(context,
                                  listen: false,);
                              con.playSong(
                                con.convertToAudio(songs),
                                songs.indexOf(song),
                              );
                            },
                            child: SongItem(
                              songs: BlocProvider.of<RecentListenCubit>(
                                context,
                              ).recentListen[index],
                              menuItem: MenuItemButtonWidget(
                                song: song,
                              ),
                            ),

                            //  ItemOfLastPlayedList(
                            //   songs: BlocProvider.of<RecentListenCubit>(context)
                            //       .recentListen[index],
                            // ),
                            //  ItemOfLastPlayedList(
                            //   songs: BlocProvider.of<RecentListenCubit>(context)
                            //       .recentListen[index],
                            // ),
                          );
                        } else if (BlocProvider.of<RecentListenCubit>(context)
                                .pageNo <=
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
                    ) : Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: NoData(
                                        height: MediaQuery.of(context).size.height / 5,
                                      ),
                      ),
                    ),
                  ],
                ),
              );
           
      },
    );
  }
}
