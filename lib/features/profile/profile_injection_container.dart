import 'package:alamoody/features/profile/data/local_datasource/profile_local_data_source.dart';
import 'package:alamoody/features/profile/domain/usecases/get_saved_login_credentials.dart';
import 'package:alamoody/features/profile/domain/usecases/save_login_credentials.dart';

import '../../injection_container.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories/profile_repository.dart';
import 'domain/repositories/profile_repository_impl.dart';
import 'domain/usecases/get_user_profile.dart';
import 'domain/usecases/update_user_profile.dart';
import 'presentation/cubits/profile/profile_cubit.dart';
import 'presentation/cubits/update_profile/update_profile_cubit.dart';

void initProfileFeature() {
// Blocs

  sl.registerFactory<UpdateProfileCubit>(
    () => UpdateProfileCubit(updateUserProfileUseCase: sl()),
  );
  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
        getUserProfileUseCase: sl(),
        getSavedProfileUseCase: sl(),
        saveProfileUseCase: sl(),),
  );

  // Use cases

  sl.registerLazySingleton<UpdateUserProfile>(
    () => UpdateUserProfile(profileRepository: sl()),
  );
  sl.registerLazySingleton<GetUserProfile>(
    () => GetUserProfile(profileRepository: sl()),
  );
  sl.registerLazySingleton<GetSavedProfileUseCase>(
    () => GetSavedProfileUseCase(profileBaseRepository: sl()),
  );
  sl.registerLazySingleton<SaveProfileUseCase>(
    () => SaveProfileUseCase(profileBaseRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProfileBaseRepository>(
    () => ProfileRepositoryImpl(
        profileRemoteDataSource: sl(), profileLocalDataSource: sl(),),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
