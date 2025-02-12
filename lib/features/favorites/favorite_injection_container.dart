


import '../../injection_container.dart';
import 'data/datasources/favorite_remote_data_source.dart';
import 'data/repositories/favorite_repository_impl.dart';
import 'domain/repositories/favorite_repository.dart';
import 'domain/usecases/add_and_remove_from_favorite.dart';
import 'domain/usecases/get_favorite.dart';
import 'presentation/cubits/add_and_remove_from_favorite/add_and_remove_from_favorite_cubit.dart';
import 'presentation/cubits/getFavorite/get_favorite_cubit.dart';

void initaFavoritesFeature() {
// Blocs


  sl.registerFactory<GetFavoriteCubit>(
    () => GetFavoriteCubit(getFavoriteUseCase: sl()),
  );
  sl.registerFactory<AddAndRemoveFromFavoritesCubit>(
    () => AddAndRemoveFromFavoritesCubit(addAndRemoveFromFavoritesUseCase: sl()),
  );

  // Use cases


  sl.registerLazySingleton<GetFavorite>(
    () => GetFavorite(favoriteRepository: sl()),
  );
  sl.registerLazySingleton<AddAndRemoveFromFavorites>(
    () => AddAndRemoveFromFavorites(favoriteRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(favoriteRemoteDataSource:sl() ),
  );

  // Data sources
  sl.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
