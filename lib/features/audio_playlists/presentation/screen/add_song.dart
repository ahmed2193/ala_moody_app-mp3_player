import 'dart:async';
import 'dart:developer';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/song_item.dart';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/cubits/recent_listen/recent_listen_cubit.dart';
import '../../../library/presentation/cubits/library/library_cubit.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  int index = -1;
  final _scrollController = ScrollController();

  final _scrollControllerForRecentListen = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String? getType() {
    if (index == 0) {
      return AppStrings.newRelease;
    } else if (index == 1) {
      return AppStrings.forYou;
    } else if (index == 2) {
      return AppStrings.popular;
    } else if (index == 3) {
      return AppStrings.upcoming;
    } else {
      return AppStrings.newRelease;
    }
  }

  Future<void> _getRecentListen() =>
      BlocProvider.of<RecentListenCubit>(context).getrecentListen(
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
      );

  void _setupScrollControllerForRecentListen(context) {
    _scrollControllerForRecentListen.addListener(() {
      if (_scrollControllerForRecentListen.position.atEdge) {
        if (_scrollControllerForRecentListen.position.pixels != 0 &&
            BlocProvider.of<RecentListenCubit>(context).pageNo <=
                BlocProvider.of<RecentListenCubit>(context).totalPages) {
          _getRecentListen();
        }
      }
    });
  }

  _getLibrary() {
    BlocProvider.of<LibraryCubit>(context).getLibrary(
      type: getType()!,
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0 &&
            BlocProvider.of<LibraryCubit>(context).pageNo <=
                BlocProvider.of<LibraryCubit>(context).totalPages) {
          _getLibrary();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<LibraryCubit>(context).clearData();
    BlocProvider.of<RecentListenCubit>(context).clearData();
    _getRecentListen();

    _getLibrary();
    _setupScrollController(context);
    _setupScrollControllerForRecentListen(context);
    super.initState();
  }

  Future<void> _refresh() {
    BlocProvider.of<LibraryCubit>(context).clearData();
    BlocProvider.of<RecentListenCubit>(context).clearData();
    _getLibrary();

    return _getRecentListen();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> names = [
      AppLocalizations.of(context)!.translate('new_release')!,
      AppLocalizations.of(context)!.translate('for_you')!,
      AppLocalizations.of(context)!.translate('popular')!,
      AppLocalizations.of(context)!.translate('upcoming')!,
    ];

    final List<Widget> body = [
      TabPageOfAddSong(
        scrollController: _scrollController,
      ),
      TabPageOfAddSong(
        scrollController: _scrollController,
      ),
      TabPageOfAddSong(
        scrollController: _scrollController,
      ),
      TabPageOfAddSong(
        scrollController: _scrollController,
      ),
    ];

    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
        key: scaffoldKey,
        body: ReusedBackground(
          body: SafeArea(
            bottom: false,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Column(
                  children: [
                    Row(children: [
                      const BackArrow(),
                      SizedBox(
                        width: context.height * 0.017,
                      ),
                      Center(
                        child: Text(
                          'add song',
                          style: styleW600(context)!
                              .copyWith(fontSize: FontSize.f18),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                    ],),
                    Expanded(
                      // height: context.height * .28,
                      child: ContainedTabBarView(
                        tabs: List.generate(
                          body.length,
                          (index) => Text(names[index]),
                        ),
                        tabBarProperties: TabBarProperties(
                          isScrollable: true,
                          alignment: TabBarAlignment.start,
                          indicatorColor: Colors.transparent,
                          background: Container(
                            color: Colors.transparent,
                          ),
                          labelColor:
                              Theme.of(context).textTheme.bodyLarge!.color,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p20,
                          ),
                          labelStyle: styleW500(
                            context,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: FontSize.f16,
                          ),
                          unselectedLabelStyle: styleW500(
                            context,
                            color: AppColors.cGreyColor,
                            fontSize: FontSize.f18,
                          ),
                          unselectedLabelColor: Theme.of(context).dividerColor,
                        ),
                        callOnChangeWhileIndexIsChanging: true,
                        onChange: (value) {
                          setState(() {
                            index = value;
                          });
                          log('index $index');
                          BlocProvider.of<LibraryCubit>(context).clearData();
                          _getLibrary();
                        },
                        views: List.generate(
                          body.length,
                          (index) => body[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabPageOfAddSong extends StatelessWidget {
  TabPageOfAddSong({
    Key? key,
    required this.scrollController,
  }) : super(key: key);
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        if (state is LibraryIsLoading && state.isFirstFetch) {
          return const LoadingIndicator();
        }
        if (state is LibraryIsLoading) {
          BlocProvider.of<LibraryCubit>(context).loadMore = true;
        } else if (state is LibraryError) {
          return Center(
            child: Text(
              // onRetryPressed: () => _getAllLibrary(),
              state.message!,
            ),
          );
        }

        return BlocProvider.of<LibraryCubit>(context).library.isNotEmpty
            ? ListView.separated(
                controller: scrollController,
                padding: const EdgeInsetsDirectional.only(
                  start: AppPadding.p10,
                  end: AppPadding.p10,
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  width: AppPadding.p4,
                ),
                itemCount: BlocProvider.of<LibraryCubit>(context)
                        .library
                        .length +
                    (BlocProvider.of<LibraryCubit>(context).loadMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index <
                      BlocProvider.of<LibraryCubit>(context).library.length) {
                    final songs =
                        BlocProvider.of<LibraryCubit>(context).library;
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
                          menuItem: IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded),
                            onPressed: () {},
                          ),
                          songs: BlocProvider.of<LibraryCubit>(context)
                              .library[index],
                        ),

                        // ItemOfLibraryCategory(
                        //   library: BlocProvider.of<LibraryCubit>(context)
                        //       .library[index],
                        // ),
                        );
                  } else if (BlocProvider.of<LibraryCubit>(context).pageNo <=
                      BlocProvider.of<LibraryCubit>(context).totalPages) {
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
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.translate("no_data")!,
                ),
              );
      },
    );
  }
}
