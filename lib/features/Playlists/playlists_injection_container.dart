import 'package:alamoody/features/Playlists/domain/usecases/create_playlist.dart';
import 'package:alamoody/features/Playlists/domain/usecases/remove_song_from_playlists.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/create_edit_playlist/create_playlist_cubit.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/remove_playlist/remove_playlist_cubit.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/remove_song_from_playlists/remove_song_from_playlists_cubit.dart';
import 'package:alamoody/injection_container.dart';

import 'data/datasources/playlists_remote_data_source.dart';
import 'data/repositories/playlists_repository_impl.dart';
import 'domain/repositories/playlists_repository.dart';
import 'domain/usecases/add_song_to_playlists.dart';
import 'domain/usecases/edit_playlist.dart';
import 'domain/usecases/get_my_playlists.dart';
import 'domain/usecases/remove_playlist.dart';
import 'presentation/cubits/add_song_to_playlists/add_song_to_playlists_cubit.dart';
import 'presentation/cubits/create_edit_playlist/edit_playlist_cubit.dart';
import 'presentation/cubits/my_playlists/my_playlists_cubit.dart';

void initaPlaylistsFeature() {
// Blocs
  sl.registerFactory<MyPlaylistsCubit>(
    () => MyPlaylistsCubit(getMyPlaylistsUseCase: sl()),
  );

  sl.registerFactory<AddSongToPlaylistsCubit>(
    () => AddSongToPlaylistsCubit(addSongToPlaylistsUseCase: sl()),
  );
  sl.registerFactory<CreatePlaylistCubit>(
    () => CreatePlaylistCubit(createPlaylistUseCase: sl()),
  );
  sl.registerFactory<RemoveSongFromPlaylistsCubit>(
    () => RemoveSongFromPlaylistsCubit(removeSongFromPlaylistsUseCase: sl()),
  );
  sl.registerFactory<RemovePlaylistCubit>(
    () => RemovePlaylistCubit(removePlaylistUseCase: sl()),
  );
  sl.registerFactory<EditPlaylistCubit>(
    () => EditPlaylistCubit(editPlaylistUseCase: sl()),
  );
  // Use cases
  sl.registerLazySingleton<GetMyPlaylists>(
    () => GetMyPlaylists(playListsRepository: sl()),
  );
  sl.registerLazySingleton<RemoveSongFromPlaylists>(
    () => RemoveSongFromPlaylists(playlistsRepository: sl()),
  );
  sl.registerLazySingleton<CreatePlaylist>(
    () => CreatePlaylist(playlistsRepository: sl()),
  );
  sl.registerLazySingleton<EditPlaylist>(
    () => EditPlaylist(playlistsRepository: sl()),
  );
  sl.registerLazySingleton<RemovePlaylist>(
    () => RemovePlaylist(playlistsRepository: sl()),
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
