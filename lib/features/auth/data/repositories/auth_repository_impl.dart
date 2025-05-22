import 'package:alamoody/features/auth/domain/usecases/update_token.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });
  @override
  Future<Either<Failure, bool>> saveLoginCredentials({
    required UserModel user,
  }) async {
    try {
      final response =
          await authLocalDataSource.saveLoginCredentials(userModel: user);
      return Right(response);
    } on CacheException {
      return const Left(CacheFailure(message: AppStrings.cacheFailure));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> updateDeviceToken({
    required UpdateTokenParams params,
  }) async {
    final res = await authRemoteDataSource.updateDeviceToken(
      params: params,
    );
    try {
      return Right(res);
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.message));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getSavedLoginCredentials() async {
    try {
      final response = await authLocalDataSource.getSavedLoginCredentials();
      return Right(response);
    } on CacheException {
      return const Left(CacheFailure(message: AppStrings.cacheFailure));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      final response = await authRemoteDataSource.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(
        ServerFailure(
          message: exception.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> register({
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await authRemoteDataSource.register(
        name: name,
        userName: userName,
        email: email,
        password: password,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(
        ServerFailure(
          message: exception.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final response = await authLocalDataSource.logout();
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String accessToken,
  }) async {
    try {
      final response = await authRemoteDataSource.resetPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> forgetPassword({
    required String email,
  }) async {
    try {
      final response = await authRemoteDataSource.forgetPassword(
        email: email,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> loginwiWthMobileNumber({
    required String phone,
    required String mobileFlag,
    required String userName,
    required String fcmToken,
  }) async {
    try {
      final response = await authRemoteDataSource.loginwiWthMobileNumber(
        phone: phone,
        mobileFlag: mobileFlag,
        userName: userName,
        fcmToken: fcmToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(
        ServerFailure(
          message: exception.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> registerWithMobileNumber({
    required String phone,
    required String mobileFlag,
    required String userName,
  }) async {
    try {
      final response = await authRemoteDataSource.registerWithMobileNumber(
        phone: phone,
        mobileFlag: mobileFlag,
        userName: userName,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(
        ServerFailure(
          message: exception.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> loginWithSocialMedia({
    required String email,
    required int isGoogle,
    required String displayName,
    required String socialId,
    required String fcmToken,
  }) async {
    try {
      final response = await authRemoteDataSource.loginWithSocialMedia(
        displayName: displayName,
        email: email,
        isGoogle: isGoogle,
        socialId: socialId,
        fcmToken: fcmToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(
        ServerFailure(
          message: exception.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> deleteAccount({
    required String accessToken,
  }) async {
    try {
      final response = await authRemoteDataSource.deleteAccount(
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
