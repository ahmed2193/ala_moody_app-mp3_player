import 'dart:async';

import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/widgets/search_bar_text_form.dart';
import '../../../main_layout/cubit/tab_cubit.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../cubits/category/category_cubit.dart';
import '../cubits/search/search_cubit.dart';
import '../widgets/tabbar_reuse.dart';
import 'pages/items/category_sections.dart';
import 'pages/tab_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool isKeyboardVisible = false;
  var con;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final keyboardIsVisible = bottomInset > 0.0;

    if (isKeyboardVisible != keyboardIsVisible) {
      setState(() {
        isKeyboardVisible = keyboardIsVisible;
      });
    }
  }

  @override
  void initState() {
    con = Provider.of<MainController>(context, listen: false);
    _getAllSearchData();
    BlocProvider.of<CategoryCubit>(context).clearData();
    WidgetsBinding.instance.addObserver(this);

    _getCategory();
    _setupScrollController();
    super.initState();
  }

  void _getAllSearchData() {
    BlocProvider.of<SearchCubit>(context).getSearch(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
      searchTxt: _searchController.text,
    );
  }

  void _getCategory() {
    BlocProvider.of<CategoryCubit>(context).getCategory(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
      searchTxt: _searchController.text,
    );
  }

  void _setupScrollController() {
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

  void _submitSearch() {
    BlocProvider.of<CategoryCubit>(context).clearData();
    _getAllSearchData();
    _getCategory();
  }

  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _submitSearch();
    });
  }


  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ReusedBackground(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04, // Decreased by 10%
                      vertical: screenHeight * 0.015, // Decreased by 10%
                    ),
                    child: Column(
                      children: [
                        if (context.read<ProfileCubit>().userProfileData !=
                                null &&
                            context
                                    .read<ProfileCubit>()
                                    .userProfileData!
                                    .user!
                                    .subscription!
                                    .serviceId ==
                                '1')
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              GestureDetector(
                                onTap: () {
                                  context.read<TabCubit>().changeTab(4);
                                },
                                child: Image.asset(ImagesPath.premiumImage),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8), // Decreased

                        // **🔍 Responsive Search Bar**
                        SearchTextFormReuse(
                          textInputAction: TextInputAction.done,
                          searchController: _searchController,
                          hintText: 'search',
                          onChanged: (value) => _onSearchChanged(value),
                          onFieldSubmitted: (value) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onClosePressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_searchController.text.isNotEmpty) {
                              _searchController.clear();
                              _submitSearch();
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8), // Decreased
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchIsLoading) {
                      return const Center(child: LoadingScreen());
                    } else if (state is SearchError) {
                      return Center(child: Text(state.message!));
                    }
                
                    final search = BlocProvider.of<SearchCubit>(context).searchData;
                
                    return Column(
                      children: [
                        // **🔹 Search Bar & Premium Banner (Adjusted Size)**
                    
                
                        // **📌 Tabs & Search Results**
                        Expanded(
                          flex: isKeyboardVisible ? 2 : 1,
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
                                      con: con,
                                      searchData: search.foryou!,
                                    ),
                                    TabPageOfCategory(
                                      con: con,
                                      searchData: search.podcasts!,
                                    ),
                                    TabPageOfCategory(
                                      con: con,
                                      searchData: search.audioBook!,
                                    ),
                                    TabPageOfCategory(
                                      con: con,
                                      searchData: search.categories!,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                
                        // **📢 Bottom Category Section (Adjusted Size)**
                        Expanded(
                          flex: 2,
                          child: CategorySectionSearchScreen(
                            onRetryPressed: () {
                              _getCategory();
                            },
                            scrollController: _scrollController,
                          ),
                        ),
                      ],
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
