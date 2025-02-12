//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart'; // //import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alamoody/features/home/presentation/screens/items/occasions_and_cat_and_generic_section.dart';
import 'package:alamoody/features/home/presentation/widgets/moode_scection.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/images.dart';
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
  const HomeScreen({Key? key, }) : super(key: key);

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
  Future<void> _getHomeData() => BlocProvider.of<HomeDataCubit>(context).getHomeData(
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
        searchTxt: _searchController.text,
      );

  _submitSearch() {
    _getHomeData();
  }



  Future<void> _getPlanData() => BlocProvider.of<PlanCubit>(context).getPlans(
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );

  @override
  void initState() {
    // getOccasions();
    // getGenres();
    _getHomeData();

    _getUserProfile();
    _getPlanData();
    super.initState();
  }

  Future<void> _refresh() {
    _searchController.clear();

    return  _getHomeData();
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
          final GlobalKey<ScaffoldState> scaffoldKey =
              GlobalKey<ScaffoldState>();
          return Scaffold(
            key: scaffoldKey,
            //  backgroundColor: Colors.blue,
            drawer: const DrawerScreen(),
            body: ReusedBackground(
              lightBG: ImagesPath.homeBGLightBG,
              body: SingleChildScrollView(
                child: SafeArea(
                  bottom: false,
                  // will control all sections from here after api integration
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SearchSection(
                            onFieldSubmitted: (value) => _submitSearch(),
                            searchController: _searchController,
                            onClosePressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_searchController.text.isNotEmpty) {
                                _searchController.clear();
// //               }
                                _submitSearch();
                              }
                            },),
                        // for premium
                        const BannerSection(),

                        BlocBuilder<HomeDataCubit, HomeDataState>(
                          builder: (context, state) {
                            if (state is HomeDataIsLoading) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: context.height * 0.103,),
                                child: const LoadingScreen(),
                              );
                            } else if (state is HomeDataError) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: context.height * 0.103,),
                                child: error_widget.ErrorWidget(
                                  onRetryPressed: () => _getHomeData(),
                                  msg: state.message!,
                                ),
                              );
                            }
                            final homeData =
                                BlocProvider.of<HomeDataCubit>(context)
                                    .homeData;
                            return homeData != null
                                ? Column(
                                    children: [
                                      HomeMoodsSection(
                                        moods: homeData.moods!,
                                      ),
                                       OccassionAndGenericCategoriesBody(
                                        items: homeData.categories!,
                                        headerName: 'album',
                                        txt: 'categories/',
                                      ),
                                  
                                      OccassionAndGenericCategoriesBody(
                                        items: homeData.genres!,
                                        headerName: 'genres',
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

                         ArtistsSection(
                                        artists: homeData.artists!,
                                      ),
                                      // Most Popular Section
                                   if (MainCubit.isDark) PopularBody(
                                        popularSongs: homeData.popularSongs!,
                                      ) else PopularLightBody(
                                        popularSongs: homeData.popularSongs!,
                                      ),

                                      // Featured List Section
                                      FeaturedListSection(
                                        songsPlayLists: homeData.playlists!,
                                      ),
                                      // Recently Play Section
                                      SizedBox(
                                        height: context.height * 0.0090,
                                      ),
                        
                                
                                      RecentlyPlaySection(
                                        recentListen: homeData.recentListens!,
                                      ),
                                      // :
                                      // LightRecentlyPlaySection(
                                      //   con: widget.con,
                                      //   recentListen: homeData.recentListens!,
                                      // ),
                                      SizedBox(
                                        height: context.height * 0.0090,
                                      ),
                                      //  !MainCubit.isDark?   ArtistsSection(
                                      //   con: widget.con,
                                      //   artists: homeData.artists!,
                                      // ):SizedBox(),
                                      // SizedBox(
                                      //   height:!MainCubit.isDark?  context.height * 0.0090:0,
                                      // ),
                                      RadioSection(
                                        radioData: homeData.radio!,
                                      ),
                                      SizedBox(
                                        height: context.height * 0.164,
                                      ),
                                    ],
                                  )
                                : const NoData();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// BlocConsumer<HomeCubit, HomeState>(
//   listener: (context, state) {},
//   builder: (context, state) {
//     final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//     return Scaffold(
//       key: scaffoldKey,
//       drawer:  DrawerScreen(con:widget.con),
//       body: ReusedBackground(
//         darKBG: ImagesPath.homeBGDarkBG,
//         lightBG: ImagesPath.homeBGLightBG,
//         body:

//         BlocProvider.of<RecentListenCubit>(context, listen: true)
//                 .isRecentLoading
//             ? const LoadingScreen()
//             : BlocProvider.of<RecentListenCubit>(context, listen: true)
//                     .isRecentError
//                 ? ErrorScreen(
//                     tryAgin: () {
//                       BlocProvider.of<PlayListsCubit>(context).clearData();
//                       BlocProvider.of<PopularSongsCubit>(context)
//                           .clearData();
//                       BlocProvider.of<RecentListenCubit>(context)
//                           .clearData();
//                       BlocProvider.of<ArtistsCubit>(context).clearData();

//                       _getUserProfile();
//                       _getPopularSongs();
//                       _getRecentListen();
//                       _getPlayListsSongs();
//                       _getArtists();
//                     },
//                   )
//                 :
//                  SingleChildScrollView(
//                     child: SafeArea(
//                       bottom: false,
//                       // will control all sections from here after api integration
//                       child: Column(
//                         children: [
//                           const SearchSection(),
//                           // for premium
//                           const BannerSection(),

//                           ArtistsSection(
//                             scrollController: _scrollControllerForArtists,
//                             con: widget.con,
//                           ),
//                           // Most Popular Section
//                           MostPopularSection(
//                             con: widget.con!,
//                             scrollController:
//                                 _scrollControllerForPopularSongs,
//                           ),
//                           // Featured List Section
//                           FeaturedListSection(
//                             con: widget.con!,
//                             scrollController:
//                                 _scrollControllerForPlayListsSongs,
//                           ),
//                           // Recently Play Section
//                           SizedBox(
//                             height: context.height * 0.0090,
//                           ),
//                           RecentlyPlaySection(
//                             con: widget.con,
//                             scrollController:
//                                 _scrollControllerForRecentListen,
//                           ),
//                              SizedBox(
//                             height: context.height * 0.0090,
//                           ),
//                                RadioSection(
//                             scrollController: _scrollControllerForArtists,
//                             con: widget.con,
//                           ),
//                           SizedBox(
//                             height: 100.h,
//                           ),
//                         ],

//                       ),
//                     ),
//                   ),

//       ),
//     );
//   },
// );
///
///import 'package:alamoody/core/helper/font_style.dart';
// import 'package:alamoody/core/utils/navigator_reuse.dart';
// import 'package:alamoody/features/notification/presentation/screen/notification_screen.dart';
// import 'package:flutter/material.dart';
// // //import 'package:flutter_screenutil/flutter_screenutil.dart'; //import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:alamoody/core/utils/media_query_values.dart';// import 'package:flutter_screenutil/flutter_screenutil.dart'; 
// //  //import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:alamoody/core/utils/media_query_values.dart';


// import '../../../../../core/helper/images.dart';
// import '../../../../../core/utils/hex_color.dart';
// import '../../widgets/icon_button_reuse.dart';
// import '../../widgets/search_bar_text_form.dart';

// class SearchSection extends StatelessWidget {
//   const SearchSection({
//     required this.onFieldSubmitted,
//     required this.searchController,
//     Key? key,
//   }) : super(key: key);
//   final ValueChanged<String>? onFieldSubmitted;

//   final TextEditingController searchController;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // sort
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: ReusedIconButton(
//             image: ImagesPath.sortIconSvg,
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//         // search textformfield
//         //  SearchTextFormReuse(
//         //                               textInputAction: TextInputAction.done,
//         //                               searchController: searchController,
//         //                               hintText: 'search',
//         //                               onFieldSubmitted: (value) =>
//         //                                   _submitSearch(),
//         //                             ),
//         Expanded(
//           child: SearchTextFormReuse(
//             // textInputAction: TextInputAction.done,

//             searchController: searchController,
//             hintText: 'search_audio_here',
//             onFieldSubmitted: onFieldSubmitted!,
//             // readOnly: true,
//           ),
//         ),
//         // equalizer
//         // Padding(
//         //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         //   child: Container(
//         //     decoration: BoxDecoration(
//         //       color: HexColor("#58585847"),
//         //       borderRadius: BorderRadius.circular(10),
//         //     ),
//         //     child:
//         //     // ),
//         //     // child: const ReusedIconButton(
//         //     //   image: ImagesPath.equalizerIconSvg,
//         //     // ),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 5),
//                 child: ReusedIconButton(
//                   onPressed: () {
//                     pushNavigate(context, const NotificationScreen());
//                   },
//                   image: ImagesPath.notificationIcon,
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 left: 3,
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: HexColor("#FF0000"),
//                   ),
//                   child: Text(
//                     '1',
//                     style: styleW700(context, fontSize: 8  

// ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
