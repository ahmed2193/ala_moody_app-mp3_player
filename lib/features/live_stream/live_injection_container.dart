
import 'package:alamoody/features/live_stream/data/datasources/live_remote_data_source.dart';
import 'package:alamoody/features/live_stream/data/repositories/live_repository_impl.dart';
import 'package:alamoody/features/live_stream/domain/repositories/live_repository.dart';
import 'package:alamoody/features/live_stream/domain/usecases/create_user_is_live.dart';
import 'package:alamoody/features/live_stream/domain/usecases/get_live_user.dart';
import 'package:alamoody/features/live_stream/presentation/cubits/create_user_is_live/create_live_user_cubit.dart';
import 'package:alamoody/features/live_stream/presentation/cubits/live_users/live_users_cubit.dart';

import '../../injection_container.dart';


void initaLiveFeature() {
// Blocs
  sl.registerFactory<LiveUsersCubit>(
    () => LiveUsersCubit(liveUsersUseCase: sl()),
  );

  sl.registerFactory<CreateUserIsLiveCubit>(
    () => CreateUserIsLiveCubit(createUserIsLiveUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetLive>(
    () => GetLive(liveRepository: sl()),
  );
  sl.registerLazySingleton<CreateUserIsLive>(
    () => CreateUserIsLive(liveRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<LiveRepository>(
    () => LiveRepositoryImpl(liveRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LiveRemoteDataSource>(
    () => LiveRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
