import 'dart:developer';

import 'package:alamoody/config/locale/app_localizations.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/cubits/recent_listen/recent_listen_cubit.dart';
import '../cubits/library/library_cubit.dart';
import 'pages/items/last_played_section.dart';
import 'pages/items/search_section.dart';
import 'pages/library_tab.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key, }) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
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
      TabPageOfLibrary(
        scrollController: _scrollController,
      ),
      TabPageOfLibrary(
        scrollController: _scrollController,
      ),
      TabPageOfLibrary(
        scrollController: _scrollController,
      ),
      TabPageOfLibrary(
        scrollController: _scrollController,
      ),
    ];

    return RefreshIndicator(
                color: Theme.of(context).primaryColor,
                key: _refreshIndicatorKey,
                onRefresh:_refresh,
      child: Scaffold(
        key: scaffoldKey,
        body: ReusedBackground(
          lightBG: ImagesPath.homeBGLightBG,
          body: SafeArea(
            bottom: false,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Column(
                  children: [
                    // all top widgets
                    const SearchSectionOfLibrary(isPremium: true),
                    const SizedBox(
                      height: AppPadding.pDefault,
                    ),
                    // tap bar & last played list
                    Expanded(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            // height: context.height * .28,
                            child: 
                            ContainedTabBarView(
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
                                ) ,
                              
                                labelColor: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p20,
                                ),
                                labelStyle: styleW500(
                                  context,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
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
                                BlocProvider.of<LibraryCubit>(context)
                                    .clearData();
                                _getLibrary();
                              },
                              views: List.generate(
                                body.length,
                                (index) => body[index],
                              ),
                            ),
                       
                          ),
                          
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                        
                              child: LastPlayedSection(
                                onRetryPressed: () {
                                  _getRecentListen();
                                  _getLibrary();
                                },
                                scrollController: _scrollControllerForRecentListen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.height * 0.074,
                    ),
                  ],
                ),
                // play control
                // const Positioned(
                //   bottom: 0.0,
                //   left: 0,
                //   right: 0,
                //   child: ControlPlayBar(),
                // ),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){
        //     MainCubit.get(context).changeThem();
        //   },
        // ),
      ),
    );
  }
}
