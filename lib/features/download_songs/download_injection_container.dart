import 'package:alamoody/features/download_songs/data/local_datasource/local_data_source.dart';
import 'package:alamoody/features/download_songs/data/remote_datasources/download_remote_datasource.dart';
import 'package:alamoody/features/download_songs/data/repositories/download_repository.dart';
import 'package:alamoody/features/download_songs/domain/repositories/base_download_repository.dart';
import 'package:alamoody/features/download_songs/domain/usecases/download_usecase.dart';
import 'package:alamoody/features/download_songs/domain/usecases/get_downloaded_songs_usecase.dart';
import 'package:alamoody/features/download_songs/presentation/cubit/download_cubit.dart';

import '../../injection_container.dart';

void initDownloadFeature() {
// Blocs
  sl.registerFactory<DownloadCubit>(
    () => DownloadCubit(
      downloadUseCase: sl(),
      getDownloadedMusicUseCase: sl(),
      // saveDownloadedMusicUseCase: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton<DownloadUseCase>(
    () => DownloadUseCase(baseDownloadRepository: sl()),
  );
  sl.registerLazySingleton<GetDownloadedMusicUseCase>(
    () => GetDownloadedMusicUseCase(baseDownloadRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<BaseDownloadRepository>(
    () => DownloadRepository(sl(), sl()),
  );
  // Data sources
  sl.registerLazySingleton<BaseDownloadDataSource>(
    () => DownloadDataSource(apiConsumer: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<BaseDownloadedLocalDataSource>(
    () => DownloadedLocalDataSource(sharedPreferences: sl()),
  );
}
