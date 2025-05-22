import 'package:alamoody/features/discover/presentation/cubits/library/discover_cubit.dart';

import '../../injection_container.dart';
import 'data/datasources/discover_remote_data_source.dart';
import 'data/repositories/discover_repository_impl.dart';
import 'domain/repositories/discover_repository.dart';
import 'domain/usecases/get_discover.dart';

void initaDiscoverFeature() {
// Blocs

  sl.registerFactory<DiscoverCubit>(
    () => DiscoverCubit(getDiscoverUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetDiscover>(
    () => GetDiscover(discoverRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<DiscoverRepository>(
    () => DiscoverRepositoryImpl(discoverRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DiscoverRemoteDataSource>(
    () => DiscoverRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
