import '../../injection_container.dart';
import 'data/datasources/following_remote_data_source.dart';
import 'data/repositories/following_repository_impl.dart';
import 'domain/repositories/following_repository.dart';
import 'domain/usecases/get_following.dart';
import 'presentation/cubits/following_cubit.dart';

void initaFollowingFeature() {
// Blocs

  sl.registerFactory<FollowingCubit>(
    () => FollowingCubit(getFollowingUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetFollowing>(
    () => GetFollowing(followingRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<FollowingRepository>(
    () => FollowingRepositoryImpl(followingRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FollowingRemoteDataSource>(
    () => FollowingRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
