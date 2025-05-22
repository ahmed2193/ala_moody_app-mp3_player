import '../../injection_container.dart';
import 'data/datasources/audio_playlists_remote_data_source.dart';
import 'data/repositories/audio_playlists_repository_impl.dart';
import 'domain/repositories/audio_playlists_repository.dart';
import 'domain/usecases/get_audio_playlists.dart';
import 'presentation/cubit/audio_playlists_cubit.dart';

void initaAudioPlayListsFeature() {
// Blocs

  sl.registerFactory<AudioPlayListsCubit>(
    () => AudioPlayListsCubit(getAudioPlayListsUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetAudioPlaylists>(
    () => GetAudioPlaylists(audioPlaylistsRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<AudioPlaylistsRepository>(
    () => AudioPlayListsRepositoryImpl(audioPlayListsRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AudioPlayListsRemoteDataSource>(
    () => AudioPlayListsRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
