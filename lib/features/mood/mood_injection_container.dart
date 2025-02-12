import '../../injection_container.dart';
import 'data/datasources/mood_remote_data_source.dart';
import 'data/repositories/category_repository_impl.dart';
import 'domain/repositories/mood_repository.dart';
import 'domain/usecases/get_mood.dart';
import 'domain/usecases/get_mood_songs.dart';
import 'presentation/cubits/mood_songs/mood_songs_cubit.dart';
import 'presentation/cubits/your_mood/your_mood_cubit.dart';

void initaMoodsFeature() {
// Blocs

  sl.registerFactory<YourMoodCubit>(
    () => YourMoodCubit(getMoodUseCase: sl()),
  );
  sl.registerFactory<MoodSongsCubit>(
    () => MoodSongsCubit(getMoodSongsUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetMood>(
    () => GetMood(moodRepository: sl()),
  );
  sl.registerLazySingleton<GetMoodSongs>(
    () => GetMoodSongs(moodRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<MoodRepository>(
    () => MoodRepositoryImpl(moodRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MoodRemoteDataSource>(
    () => MoodRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
