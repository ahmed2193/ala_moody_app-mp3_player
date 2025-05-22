import 'dart:async';

import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/menu_item_button.dart';
import '../../../../core/utils/no_data.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../cubits/mood_songs/mood_songs_cubit.dart';
import '../cubits/your_mood/your_mood_cubit.dart';

class MoodSongsScreen extends StatefulWidget {
  const MoodSongsScreen({
    this.id,
    this.name,
    Key? key,
  }) : super(key: key);
  final id;
  final name;
  @override
  State<MoodSongsScreen> createState() => _MoodSongsScreenState();
}

class _MoodSongsScreenState extends State<MoodSongsScreen> {
  ScrollController scrollController = ScrollController();

  getMoodsongs() {
    BlocProvider.of<MoodSongsCubit>(context).getMoodSongs(
      id: widget.id ?? BlocProvider.of<YourMoodCubit>(context).selectedMood!.id,
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<MoodSongsCubit>(context).pageNo <=
                BlocProvider.of<MoodSongsCubit>(context).totalPages) {
          getMoodsongs();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<MoodSongsCubit>(context).clearData();

    getMoodsongs();

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
                  Text(
                    widget.name != null
                        ? widget.name +
                            AppLocalizations.of(context)!
                                .translate("audio_list")!
                        : BlocProvider.of<YourMoodCubit>(context)
                                .selectedMood!
                                .name! +
                            AppLocalizations.of(context)!
                                .translate("audio_list")!,
                    style: styleW600(context)!.copyWith(fontSize: FontSize.f18),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<MoodSongsCubit, MoodSongsState>(
                  builder: (context, state) {
                    if (state is MoodSongsIsLoading && state.isFirstFetch) {
                      return const LoadingScreen();
                    }
                    if (state is MoodSongsIsLoading) {
                      BlocProvider.of<MoodSongsCubit>(context).loadMore = true;
                    } else if (state is MoodSongsError) {
                      return error_widget.ErrorWidget(
                        onRetryPressed: () {
                          BlocProvider.of<MoodSongsCubit>(context).clearData();

                          getMoodsongs();
                        },
                        msg: state.message!,
                      );
                    }

                    return BlocProvider.of<MoodSongsCubit>(context)
                            .moodSongs
                            .isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.pDefault,
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsetsDirectional.only(
                                top: AppPadding.p20,
                                bottom: AppPadding.p20 * 6,
                              ),
                              // physics: const NeverScrollableScrollPhysics(),
                              controller: scrollController,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: AppPadding.p20,
                              ),
                              itemCount:
                                  BlocProvider.of<MoodSongsCubit>(context)
                                          .moodSongs
                                          .length +
                                      (BlocProvider.of<MoodSongsCubit>(context)
                                              .loadMore
                                          ? 1
                                          : 0),
                              itemBuilder: (context, index) {
                                if (index <
                                    BlocProvider.of<MoodSongsCubit>(context)
                                        .moodSongs
                                        .length) {
                                  return GestureDetector(
                                    onTap: () {
                                      final con = Provider.of<MainController>(
                                        context,
                                        listen: false,
                                      );
                                      final items =
                                          BlocProvider.of<MoodSongsCubit>(
                                        context,
                                      ).moodSongs;
                                      con.playSong(
                                        con.convertToAudio(items),
                                        items.indexOf(items[index]),
                                      );
                                    },
                                    child: SongItem(
                                      songs: BlocProvider.of<MoodSongsCubit>(
                                        context,
                                      ).moodSongs[index],
                                      menuItem: MenuItemButtonWidget(
                                        song: BlocProvider.of<MoodSongsCubit>(
                                          context,
                                        ).moodSongs[index],
                                      ),
                                    ),
                                  );

                                  // ItemOfLastPlayedList(
                                  //   songs:
                                  //       BlocProvider.of<MoodSongsCubit>(context)
                                  //           .moodSongs[index],
                                  // );
                                } else if (BlocProvider.of<MoodSongsCubit>(
                                      context,
                                    ).pageNo <=
                                    BlocProvider.of<MoodSongsCubit>(context)
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
                        : const Center(
                            child: NoData(),
                          );
                  },
                ),
              ),
              SizedBox(
                height: context.height * 0.116,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
