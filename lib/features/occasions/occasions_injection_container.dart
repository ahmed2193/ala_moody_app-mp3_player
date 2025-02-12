import '../../injection_container.dart';
import 'data/datasources/occasions_remote_data_source.dart';
import 'data/repositories/occasions_repository_impl.dart';
import 'domain/repositories/occasions_repository.dart';
import 'domain/usecases/get_occasions.dart';
import 'presentation/cubits/occasions_cubit.dart';

void initaOccasionsFeature() {
// Blocs

  sl.registerFactory<OccasionsCubit>(
    () => OccasionsCubit(getOccasionsUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetOccasions>(
    () => GetOccasions(occasionsRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<OccasionsRepository>(
    () => OccasionsRepositoryImpl(occasionsRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<OccasionsRemoteDataSource>(
    () => OccasionsRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
