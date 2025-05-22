import 'package:alamoody/features/ads/ads_injection_container.dart';
import 'package:alamoody/features/contact_us/contact_us_injection_container.dart';
import 'package:alamoody/features/discover/discover_injection_container.dart';
import 'package:alamoody/features/download_songs/download_injection_container.dart';
import 'package:alamoody/features/following/following_injection_container.dart';
import 'package:alamoody/features/genres/genres_injection_container.dart';
import 'package:alamoody/features/membership/plan_injection_container.dart';
import 'package:alamoody/features/occasions/occasions_injection_container.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'features/Playlists/playlists_injection_container.dart';
import 'features/audio_playlists/audio_playlists_injection_container.dart';
import 'features/auth/auth_injection_container.dart';
import 'features/favorites/favorite_injection_container.dart';
import 'features/home/home_injection_container.dart';
import 'features/library/library_injection_container.dart';
import 'features/live_stream/live_injection_container.dart';
import 'features/main/data/datasources/lang_local_data_source.dart';
import 'features/main/data/repositories/lang_repository_impl.dart';
import 'features/main/domain/repositories/lang_repository.dart';
import 'features/main/domain/usecases/change_lang.dart';
import 'features/main/domain/usecases/get_saved_lang.dart';
import 'features/main/presentation/cubit/locale_cubit.dart';
import 'features/mood/mood_injection_container.dart';
import 'features/notification/notification_injection_container.dart';
import 'features/profile/profile_injection_container.dart';
import 'features/radio/radio_injection_container.dart';
import 'features/search/search_injection_container.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Blocs
  sl.registerFactory<LocaleCubit>(
    () => LocaleCubit(changeLangUseCase: sl(), getSavedLangUseCase: sl()),
  );
  // Use cases
  sl.registerLazySingleton<GetSavedLang>(
    () => GetSavedLang(langRepository: sl()),
  );
  sl.registerLazySingleton<ChangeLang>(() => ChangeLang(langRepository: sl()));
  // Repository
  sl.registerLazySingleton<LangRepository>(
    () => LangRepositoryImpl(langLocalDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<LangLocalDataSource>(
    () => LangLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // MainController con= MainController();
  // Features
  initAuthFeature();
  initProfileFeature();
  initaHomeFeature();
  initaLibraryFeature();
  initaSearchFeature();
  initLikedProjectsFeature();
  initaMoodsFeature();
  initaAudioPlayListsFeature();
  initaFavoritesFeature();
  initaNotificationsFeature();
  initaRadioFeature();
  initaPlaylistsFeature();
  initDownloadFeature();
  initPlanFeature();
  initaLiveFeature();
  initaDiscoverFeature();
  initaOccasionsFeature();
  initaGenresFeature();
  initaFollowingFeature();
  initaAdsFeature();
  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  sl.registerLazySingleton(
    () => LogInterceptor(
      responseBody: true,
      requestBody: true,
    ),
  );
  sl.registerLazySingleton(() => AppIntercepters(langLocalDataSource: sl()));
}
