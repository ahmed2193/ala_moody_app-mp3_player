import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/no_data.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/widgets/search_bar_text_form.dart';
import '../../../main_layout/cubit/tab_cubit.dart';
import '../../../main_layout/presentation/pages/main_layout_screen.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../cubits/category/category_cubit.dart';
import '../cubits/search/search_cubit.dart';
import '../widgets/tabbar_reuse.dart';
import 'pages/items/category_sections.dart';
import 'pages/tab_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.con}) : super(key: key);
  final MainController con;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>  with WidgetsBindingObserver{
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
    bool isKeyboardVisible = false;


   @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Check if the keyboard is open or closed
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final keyboardIsVisible = bottomInset > 0.0;

    if (isKeyboardVisible != keyboardIsVisible) {
      setState(() {
        isKeyboardVisible = keyboardIsVisible;
      });
    }
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  _getAllSearchData() {
    BlocProvider.of<SearchCubit>(context).getSearch(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
      searchTxt: _searchController.text,
    );
  }

  void _getCategory() {
    BlocProvider.of<CategoryCubit>(context).getCategory(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setup_scrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0 &&
            BlocProvider.of<CategoryCubit>(context).pageNo <=
                BlocProvider.of<CategoryCubit>(context).totalPages) {
          _getCategory();
        }
      }
    });
  }

  @override
  void initState() {
    _getAllSearchData();
    BlocProvider.of<CategoryCubit>(context).clearData();
    WidgetsBinding.instance.addObserver(this);

    _getCategory();
    _setup_scrollController(context);
    super.initState();
  }

  _submitSearch() {
    _getAllSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Future<void> _refresh() {
    _searchController.clear();

    return _getAllSearchData();
  }

  Widget _buildBodyContent() {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
        body: ReusedBackground(
          lightBG: ImagesPath.homeBGLightBG,
          body: SafeArea(
            bottom: false,
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchIsLoading) {
                  return const LoadingScreen();
                } else if (state is SearchError) {
                  return error_widget.ErrorWidget(
                    onRetryPressed: () => _getAllSearchData(),
                    msg: state.message!,
                  );
                }
                final search = BlocProvider.of<SearchCubit>(context).searchData;
                return Column(
                  children: [
                    // search && back icon && premium image
                    // CategorySearchSection(isPremium: true),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: AppPadding.pDefault,
                        start: AppPadding.pDefault,
                        top: AppPadding.p10,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // back and premium image
                            if (  context.read<ProfileCubit>().userProfileData != null &&
            context
                    .read<ProfileCubit>()
                    .userProfileData!
                    .user!
                    .subscription!
                    .serviceId ==
                '1')
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  GestureDetector(
                                    onTap: () {
                                     context
                                                .read<TabCubit>()
                                                .changeTab(4);
                                    },
                                    child: Image.asset(
                                      ImagesPath.premiumImage,
                                    ),
                                  ),
                                ],
                              )
                            else
                              const SizedBox(),
                            const SizedBox(
                              height: AppPadding.p20,
                            ),
                            SearchTextFormReuse(
                              textInputAction: TextInputAction.done,
                              searchController: _searchController,
                              hintText: 'search',
                              onFieldSubmitted: (value) => _submitSearch(),
                              onClosePressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_searchController.text.isNotEmpty) {
                                  _searchController.clear();
// //               }
                                  _submitSearch();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: AppPadding.p20,
                    ),
                    Expanded(flex:isKeyboardVisible?2:1,
                      child: search != null
                          ? TabBarReuse(
                              names: [
                                AppLocalizations.of(context)!
                                    .translate("for_you")!,
                                AppLocalizations.of(context)!
                                    .translate("podcast")!,
                                AppLocalizations.of(context)!
                                    .translate("audioBook")!,
                                AppLocalizations.of(context)!
                                    .translate("stories")!,
                              ],
                              body: [
                                TabPageOfCategory(
                                  con: widget.con,
                                  searchData: search.foryou!,
                                ),
                                TabPageOfCategory(
                                  con: widget.con,
                                  searchData: search.podcasts!,
                                ),
                                TabPageOfCategory(
                                  con: widget.con,
                                  searchData: search.audioBook!,
                                ),
                                TabPageOfCategory(
                                  con: widget.con,
                                  searchData: search.categories!,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),

                    Expanded(
                      flex: 2,
                        child: CategorySectionSearchScreen(
                      onRetryPressed: () {
                        _getCategory();
                      },
                      scrollController: _scrollController,
                    ))
                  ],
                );
                // : const NoData();
              },
            ),
          ),
        ),
      ),
    );
  }
}
