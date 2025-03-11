import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/remove_song_from_playlists/remove_song_from_playlists_cubit.dart';
import 'package:alamoody/features/auth/presentation/screen/login_screen.dart';
import 'package:alamoody/features/contact_us/presentation/cubit/contact_us_cubit.dart';
import 'package:alamoody/features/download_songs/presentation/cubit/download_cubit.dart';
import 'package:alamoody/features/genres/presentation/cubits/genres_cubit.dart';
import 'package:alamoody/features/home/presentation/cubits/set_ringtones/set_ringtones_cubit.dart';
import 'package:alamoody/features/main/presentation/screens/welcome_screen/welcome_screen.dart';
import 'package:alamoody/features/main_layout/cubit/tab_cubit.dart';
import 'package:alamoody/features/main_layout/presentation/pages/main_layout_screen.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:alamoody/features/occasions/presentation/cubits/occasions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'config/locale/app_localizations_setup.dart';
import 'config/themes/dark.dart';
import 'config/themes/light.dart';
import 'features/Playlists/presentation/cubits/add_song_to_playlists/add_song_to_playlists_cubit.dart';
import 'features/Playlists/presentation/cubits/create_edit_playlist/create_playlist_cubit.dart';
import 'features/Playlists/presentation/cubits/create_edit_playlist/edit_playlist_cubit.dart';
import 'features/Playlists/presentation/cubits/my_playlists/my_playlists_cubit.dart';
import 'features/Playlists/presentation/cubits/remove_playlist/remove_playlist_cubit.dart';
import 'features/audio_playlists/presentation/cubit/audio_playlists_cubit.dart';
import 'features/auth/presentation/cubit/login/login_cubit.dart';
import 'features/auth/presentation/cubit/register/register_cubit.dart';
import 'features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'features/discover/presentation/cubits/library/discover_cubit.dart';
import 'features/favorites/presentation/cubits/add_and_remove_from_favorite/add_and_remove_from_favorite_cubit.dart';
import 'features/favorites/presentation/cubits/getFavorite/get_favorite_cubit.dart';
import 'features/following/presentation/cubits/following_cubit.dart';
import 'features/home/presentation/cubits/artist_details/artist_details_cubit.dart';
import 'features/home/presentation/cubits/artists/artists_cubit.dart';
import 'features/home/presentation/cubits/follow_and_unfollow/follow_and_unfollow_cubit.dart';
import 'features/home/presentation/cubits/home_cubit.dart';
import 'features/home/presentation/cubits/play_lists/play_lists_cubit.dart';
import 'features/home/presentation/cubits/popular_songs/popular_songs_cubit.dart';
import 'features/home/presentation/cubits/recent_listen/recent_listen_cubit.dart';
import 'features/home/presentation/cubits/save_song_on_track_play/save_song_on_track_play_cubit.dart';
import 'features/home/presentation/cubits/search/home_data_cubit.dart';
import 'features/library/presentation/cubits/library/library_cubit.dart';
import 'features/live_stream/presentation/cubits/create_user_is_live/create_live_user_cubit.dart';
import 'features/live_stream/presentation/cubits/live_users/live_users_cubit.dart';
import 'features/main/presentation/cubit/locale_cubit.dart';
import 'features/main/presentation/cubit/main_cubit.dart';
import 'features/membership/presentation/cubit/coupon_cubit/coupon_cubit.dart';
import 'features/membership/presentation/cubit/unsubscribe_plan_cubit/unsubscribe_plan_cubit.dart';
import 'features/mood/presentation/cubits/mood_songs/mood_songs_cubit.dart';
import 'features/mood/presentation/cubits/your_mood/your_mood_cubit.dart';
import 'features/notification/presentation/cubits/get_notification/get_notification_cubit.dart';
import 'features/profile/presentation/cubits/profile/profile_cubit.dart';
import 'features/radio/presentation/cubits/radio/radio_cubit.dart';
import 'features/radio/presentation/cubits/radio_category/radio_category_cubit.dart';
import 'features/search/presentation/cubits/category/category_cubit.dart';
import 'features/search/presentation/cubits/search/search_cubit.dart';
import 'features/search_song/presentation/cubit/search_song_cubit.dart';
import 'injection_container.dart' as di;

class AlaMoodyApp extends StatefulWidget {
  const AlaMoodyApp({super.key});

  @override
  State<AlaMoodyApp> createState() => _AlaMoodyAppState();
}

class _AlaMoodyAppState extends State<AlaMoodyApp> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainController>(
      create: (context) {
        return MainController();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => di.sl<LocaleCubit>()..getSavedLang(),
          ),
          BlocProvider(
            create: (_) => di.sl<LoginCubit>()..getSavedLoginCredentials(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => di.sl<ProfileCubit>()..getSavedProfileData(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => di.sl<RegisterCubit>(),
          ),
          BlocProvider(
            create: (context) => MainCubit(),
          ),
          BlocProvider(
            create: (context) => HomeCubit(),
          ),
          BlocProvider(
            create: (_) => di.sl<ResetPasswordCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<ContactUsCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<HomeDataCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<LibraryCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<PlanCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<SaveSongOnTrackPlayCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<PopularSongsCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<PlayListsCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<RecentListenCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<CategoryCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<DownloadCubit>()..getSavedDownloads(),
          ),
          BlocProvider(
            create: (_) => di.sl<YourMoodCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<MoodSongsCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<AudioPlayListsCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<GetFavoriteCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<AddAndRemoveFromFavoritesCubit>(),
          ),
          BlocProvider(
            create: (_) => di.sl<SearchCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<ArtistsCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<ArtistDetailsCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<FollowAndUnFollowCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<GetNotificationCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<RadioCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<RadioCategoryCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<MyPlaylistsCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<CreatePlaylistCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<AddSongToPlaylistsCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<RemoveSongFromPlaylistsCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<LiveUsersCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<DiscoverCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<UnsubscribePlanCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<SetRingtonesCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<OccasionsCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<GenresCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<FollowingCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<CouponCubit>(),
          ),
          BlocProvider(
            create: (context) => SearchSongCubit(),
          ),
          BlocProvider(
            create: (context) => di.sl<CreateUserIsLiveCubit>()
              ..createUserIsLive(
                accessToken: context
                    .read<LoginCubit>()
                    .authenticatedUser!
                    .accessToken!,
                isLive: '0',
              ),
          ),
          BlocProvider(
            create: (context) => di.sl<EditPlaylistCubit>(),
          ),
          BlocProvider(
            create: (context) => di.sl<RemovePlaylistCubit>(),
          ),
          BlocProvider(create: (context) => TabCubit()),
        ],
        child: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            return BlocBuilder<LocaleCubit, LocaleState>(
              buildWhen: (previousState, currentState) =>
                  previousState != currentState,
              builder: (_, localeState) {
                return MaterialApp(
                  navigatorKey:
                      navigatorKey, // ✅ Assign the global navigator key
                  title: 'Ala Moody',
                  debugShowCheckedModeBanner: false,
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegates,
                  localeResolutionCallback:
                      AppLocalizationsSetup.localeResolutionCallback,
                  locale: localeState.locale,
                  // onGenerateRoute: AppRoutes.onGenerateRoute,
                  // initialRoute: Routes.mainRoute,
                  theme: lightTheme(),
                  darkTheme: darkTheme(),
                  themeMode: MainCubit.isDark == true
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: ScrollConfiguration(
                        behavior: NoGlowBehavior(),
                        child: child!,
                      ),
                    );
                  },
                  home: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      if (state is Authenticated) {
                        return const MainLayoutScreen();
      
                        // App();
                      } else if (state is UnAuthenticated) {
                        return const LoginScreen();
                      } else {
                        return const WelcomeScreen();
                      }
                    },
                  ),
                  //
                  // EasySplashScreen(
                  //   logo: Image.asset(
                  //     ImagesPath.logoImage,
                  //   ),
                  //   logoWidth: 200,
                  //   showLoader: false,
                  //   backgroundColor: Colors.transparent,
                  //   backgroundImage: AssetImage(
                  //     MainCubit.isDark == true
                  //         ? ImagesPath.darkBG
                  //         : ImagesPath.lightBG,
                  //   ),
      
                  //   // navigator:  LiveTest(),
      
                  //   //PlayerScreen(),
                  //   //Test() //PlayerScreen(), //WelcomeScreen(),//FavoritesScreen//DownloadsScreen
                  // ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection? axisDirection,
  ) {
    return child;
  }
}
