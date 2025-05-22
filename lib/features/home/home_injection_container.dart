import 'package:alamoody/features/home/domain/usecases/set_ringtones.dart';
import 'package:alamoody/features/home/presentation/cubits/set_ringtones/set_ringtones_cubit.dart';

import '../../injection_container.dart';
import 'data/datasources/home_remote_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/follow_and_unfollow.dart';
import 'domain/usecases/get_artists.dart';
import 'domain/usecases/get_artists_details.dart';
import 'domain/usecases/get_play_lists.dart';
import 'domain/usecases/get_popular_songs.dart';
import 'domain/usecases/get_recent_listen.dart';
import 'domain/usecases/home_data.dart';
import 'domain/usecases/save_song_on_track_play.dart';
import 'presentation/cubits/artist_details/artist_details_cubit.dart';
import 'presentation/cubits/artists/artists_cubit.dart';
import 'presentation/cubits/follow_and_unfollow/follow_and_unfollow_cubit.dart';
import 'presentation/cubits/play_lists/play_lists_cubit.dart';
import 'presentation/cubits/popular_songs/popular_songs_cubit.dart';
import 'presentation/cubits/recent_listen/recent_listen_cubit.dart';
import 'presentation/cubits/save_song_on_track_play/save_song_on_track_play_cubit.dart';
import 'presentation/cubits/search/home_data_cubit.dart';

void initaHomeFeature() {
// Blocs
  sl.registerFactory<PopularSongsCubit>(
    () => PopularSongsCubit(getPopularSongsUseCase: sl()),
  );

  sl.registerFactory<PlayListsCubit>(
    () => PlayListsCubit(getPlayListsUseCase: sl()),
  );
  sl.registerFactory<RecentListenCubit>(
    () => RecentListenCubit(getRecentListenUseCase: sl()),
  );
  sl.registerFactory<SaveSongOnTrackPlayCubit>(
    () => SaveSongOnTrackPlayCubit(saveSongOnTrackPlayUseCase: sl()),
  );
  sl.registerFactory<SetRingtonesCubit>(
    () => SetRingtonesCubit(setRingtonesUseCase: sl()),
  );
  sl.registerFactory<ArtistsCubit>(
    () => ArtistsCubit(getArtistsUseCase: sl()),
  );
  sl.registerFactory<ArtistDetailsCubit>(
    () => ArtistDetailsCubit(artistDetailsUseCase: sl()),
  );
  sl.registerFactory<FollowAndUnFollowCubit>(
    () => FollowAndUnFollowCubit(followAndUnFollowUseCase: sl()),
  );
  sl.registerFactory<HomeDataCubit>(
    () => HomeDataCubit(homeDataUseCase: sl()),
  );
  // Use cases
  sl.registerLazySingleton<GetPopularSongs>(
    () => GetPopularSongs(popularSongsRepository: sl()),
  );
  sl.registerLazySingleton<GetPlaylists>(
    () => GetPlaylists(playListsRepository: sl()),
  );
  sl.registerLazySingleton<GetRecentListen>(
    () => GetRecentListen(recentListenRepository: sl()),
  );
  sl.registerLazySingleton<GetArtists>(
    () => GetArtists(artistsRepository: sl()),
  );
  sl.registerLazySingleton<GetArtistDetails>(
    () => GetArtistDetails(artistDetailsRepository: sl()),
  );
  sl.registerLazySingleton<SaveSongOnTrackPlay>(
    () => SaveSongOnTrackPlay(homeRepository: sl()),
  );
  sl.registerLazySingleton<SetRingtones>(
    () => SetRingtones(homeRepository: sl()),
  );
  sl.registerLazySingleton<FollowAndUnFollow>(
    () => FollowAndUnFollow(followAndUnFollowRepository: sl()),
  );
  sl.registerLazySingleton<HomeDataUseCase>(
    () => HomeDataUseCase(homeDataUseCaseRepository: sl()),
  );
  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(homeRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
