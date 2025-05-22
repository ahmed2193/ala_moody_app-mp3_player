//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:async';

import 'package:alamoody/core/utils/media_query_values.dart'; // //import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alamoody/features/home/presentation/screens/items/occasions_and_cat_and_generic_section.dart';
import 'package:alamoody/features/home/presentation/screens/items/moode_scection.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/utils/no_data.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../drawer/presentation/screens/drawer_screen.dart';
import '../../../main/presentation/cubit/main_cubit.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../cubits/home_cubit.dart';
import '../cubits/search/home_data_cubit.dart';
import 'items/artists_section.dart';
import 'items/banner_section.dart';
import 'items/featured_list_section.dart';
import 'items/most_popular_section.dart';
import 'items/radio_section.dart';
import 'items/recently_play_section.dart';
import 'items/search_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final formKey = GlobalKey<FormState>();

  Future<void> _getUserProfile() async =>
      BlocProvider.of<ProfileCubit>(context).getUserProfile(
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );

  Future<void> _getHomeData() =>
      BlocProvider.of<HomeDataCubit>(context).getHomeData(
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
        searchTxt: _searchController.text,
      );

  Future<void> _getPlanData() => BlocProvider.of<PlanCubit>(context).getPlans(
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _getHomeData();
    });
  }

  @override
  void initState() {
    _debounce?.cancel();
    _getHomeData();
    _getUserProfile();
    _getPlanData();
    super.initState();
  }

  Future<void> _refresh() async {
    _searchController.clear();
    return _getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            drawer: const DrawerScreen(),
            body: ReusedBackground(
              body: SafeArea(
                bottom: false,
                child: CustomScrollView(
                  slivers: [
                    // Search Bar Section
                    SliverToBoxAdapter(
                      child: SearchSection(
                        onChanged: (value) => _onSearchChanged(value),
                        onFieldSubmitted: (value) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        searchController: _searchController,
                        onClosePressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_searchController.text.isNotEmpty) {
                            _searchController.clear();
                            _getHomeData();
                          }
                        },
                      ),
                    ),

                    // Banner Section
                    const SliverToBoxAdapter(child: BannerSection()),

                    // Home Data Sections
                    BlocBuilder<HomeDataCubit, HomeDataState>(
                      builder: (context, state) {
                        if (state is HomeDataIsLoading) {
                          return const SliverFillRemaining(
                            child: Center(child: LoadingScreen()),
                          );
                        } else if (state is HomeDataError) {
                          return SliverFillRemaining(
                            child: error_widget.ErrorWidget(
                              onRetryPressed: () => _getHomeData(),
                              msg: state.message!,
                            ),
                          );
                        }

                        final homeData = context.read<HomeDataCubit>().homeData;
                        if (homeData == null) {
                          return const SliverFillRemaining(child: NoData());
                        }

                        return SliverList(
                          delegate: SliverChildListDelegate([
                            // Mood Section
                            MoodsBody(items: homeData.moods!),

                            // Categories, Genres, Occasions Sections
                            OccassionAndGenericCategoriesBody(
                              items: homeData.categories!,
                              headerName: 'album',
                              txt: 'categories/',
                            ),
                            OccassionAndGenericCategoriesBody(
                              items: homeData.genres!,
                              headerName: 'main',
                              txt: 'genres/',
                            ),
                            OccassionAndGenericCategoriesBody(
                              items: homeData.occasions!,
                              headerName: 'occasions',
                              txt: 'occasions/',
                            ),
                            OccassionAndGenericCategoriesBody(
                              items: homeData.categories!,
                              headerName: 'categories',
                              txt: 'categories/',
                            ),

                            // Artists Section
                            ArtistsSection(artists: homeData.artists!),

                            // Most Popular Section
                            PopularBody(popularSongs: homeData.popularSongs!),
                            // if (MainCubit.isDark)
                            //   PopularBody(popularSongs: homeData.popularSongs!)
                            // else
                            //   PopularLightBody(popularSongs: homeData.popularSongs!),

                            // Featured List Section
                            FeaturedListSection(
                                songsPlayLists: homeData.playlists!),

                            // Recently Played Section
                            RecentlyPlaySection(
                                recentListen: homeData.recentListens!),

                            // Radio Section
                            RadioSection(radioData: homeData.radio!),

                            // Bottom Spacer
                            SizedBox(height: context.height * 0.164),
                          ]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
