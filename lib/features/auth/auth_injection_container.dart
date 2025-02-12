import 'package:alamoody/features/auth/domain/usecases/delete_account.dart';
import 'package:alamoody/features/auth/domain/usecases/login_with_mobile_number.dart';
import 'package:alamoody/features/auth/domain/usecases/login_with_soial_media.dart';
import 'package:alamoody/features/auth/domain/usecases/register_with_mobile_number.dart';
import 'package:alamoody/features/auth/domain/usecases/update_token.dart';

import '../../injection_container.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/forget_password%20.dart';
import 'domain/usecases/get_saved_login_credentials.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/logout.dart';
import 'domain/usecases/register.dart';
import 'domain/usecases/reset_password.dart';
import 'domain/usecases/save_login_credentials.dart';
import 'presentation/cubit/forget_password/forget_password_cubit.dart';
import 'presentation/cubit/login/login_cubit.dart';
import 'presentation/cubit/register/register_cubit.dart';
import 'presentation/cubit/reset_password/reset_password_cubit.dart';

void initAuthFeature() {
// Blocs
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: sl(),
      updateTokenUseCase: sl(),
      logoutUseCase: sl(),
      getSavedLoginCredentialsUseCase: sl(),
      saveLoginCredentials: sl(),
      loginWithSoialMediaUseCase: sl(),
      loginWithMobileNumberUseCase: sl(),
     deleteAccountUseCase: sl(),
    ),
  );

  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(
      registerUseCase: sl(),
      registerWithMobileNumberUseCase: sl(),
    ),
  );

  sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(
      resetPasswordUseCase: sl(),
    ),
  );
  sl.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(
      forgetPasswordUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<Login>(() => Login(authRepository: sl()));
  sl.registerLazySingleton<LoginWithSoialMedia>(
    () => LoginWithSoialMedia(authRepository: sl()),
  );
  sl.registerLazySingleton<DeleteAccount>(
    () => DeleteAccount(authRepository: sl()),
  );
  sl.registerLazySingleton<Register>(() => Register(authRepository: sl()));
  sl.registerLazySingleton<GetSavedLoginCredentials>(
    () => GetSavedLoginCredentials(authRepository: sl()),
  );
  sl.registerLazySingleton<UpdateTokenUseCase>(
      () => UpdateTokenUseCase(authRepository: sl()),);
  sl.registerLazySingleton<SaveLoginCredentials>(
    () => SaveLoginCredentials(authRepository: sl()),
  );
  sl.registerLazySingleton<Logout>(() => Logout(authRepository: sl()));
  sl.registerLazySingleton<ResetPassword>(
    () => ResetPassword(authRepository: sl()),
  );
  sl.registerLazySingleton<ForgetPassword>(
    () => ForgetPassword(authRepository: sl()),
  );
  sl.registerFactory<LoginWithMobileNumber>(
    () => LoginWithMobileNumber(authRepository: sl()),
  );
  sl.registerFactory<RegisterWithMobileNumber>(
    () => RegisterWithMobileNumber(authRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
