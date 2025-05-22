import '../../injection_container.dart';
import 'data/datasources/occasions_remote_data_source.dart';
import 'data/repositories/genres_repository_impl.dart';
import 'domain/repositories/genres_repository.dart';
import 'domain/usecases/get_genres.dart';
import 'presentation/cubits/genres_cubit.dart';

void initaGenresFeature() {
// Blocs

  sl.registerFactory<GenresCubit>(
    () => GenresCubit(getGenresUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetGenres>(
    () => GetGenres(genresRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<GenresRepository>(
    () => GenresRepositoryImpl(genresRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<GenresRemoteDataSource>(
    () => GenresRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
