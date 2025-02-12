import 'package:alamoody/features/Playlists/domain/usecases/create_playlists.dart';
import 'package:alamoody/features/Playlists/domain/usecases/remove_song_from_playlists.dart';
import 'package:alamoody/injection_container.dart';

import 'data/datasources/playlists_remote_data_source.dart';
import 'data/repositories/playlists_repository_impl.dart';
import 'domain/repositories/playlists_repository.dart';
import 'domain/usecases/add_song_to_playlists.dart';
import 'domain/usecases/get_my_playlists.dart';
import 'presentation/cubits/add_song_to_playlists/add_song_to_playlists_cubit.dart';
import 'presentation/cubits/create_playlists/create_playlists_cubit.dart';
import 'presentation/cubits/my_playlists/my_playlists_cubit.dart';
import 'presentation/cubits/remove_song_from_playlists/remove_song_from_playlists_cubit.dart';

void initaPlaylistsFeature() {
// Blocs
  sl.registerFactory<MyPlaylistsCubit>(
    () => MyPlaylistsCubit(getMyPlaylistsUseCase: sl()),
  );

  sl.registerFactory<AddSongToPlaylistsCubit>(
    () => AddSongToPlaylistsCubit(addSongToPlaylistsUseCase: sl()),
  );
  sl.registerFactory<CreatePlaylistsCubit>(
    () => CreatePlaylistsCubit(createPlaylistsUseCase: sl()),
  );
  sl.registerFactory<RemoveSongFromPlaylistsCubit>(
    () => RemoveSongFromPlaylistsCubit(removeSongFromPlaylistsUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetMyPlaylists>(
    () => GetMyPlaylists(playListsRepository: sl()),
  );
  sl.registerLazySingleton<RemoveSongFromPlaylists>(
    () => RemoveSongFromPlaylists(playlistsRepository: sl()),
  );
  sl.registerLazySingleton<CreatePlaylists>(
    () => CreatePlaylists(playlistsRepository: sl()),
  );
  sl.registerLazySingleton<AddSongToPlaylists>(
    () => AddSongToPlaylists(playlistsRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<PlaylistsRepository>(
    () => PlayListsRepositoryImpl(playListsRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PlayListsRemoteDataSource>(
    () => PlayListsRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
