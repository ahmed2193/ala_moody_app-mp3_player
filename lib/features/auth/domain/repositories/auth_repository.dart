import 'package:alamoody/features/auth/domain/usecases/update_token.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, BaseResponse>> login({
    required String email,
    required String password,
    required String fcmToken,
  });
  Future<Either<Failure, BaseResponse>> loginWithSocialMedia({
    required String email,
    required int isGoogle,
    required String displayName,
    required String socialId,
    required String fcmToken,
  });

  Future<Either<Failure, BaseResponse>> register({
    required String name,
    required String userName,
    required String email,
    required String password,
  });
  Future<Either<Failure, BaseResponse>> loginwiWthMobileNumber({
    required String phone,
    required String mobileFlag,
    required String userName,
    required String fcmToken,
  });
  Future<Either<Failure, BaseResponse>> updateDeviceToken({
    required UpdateTokenParams params,
  });
  Future<Either<Failure, BaseResponse>> registerWithMobileNumber({
    required String phone,
    required String mobileFlag,
    required String userName,
  });

  Future<Either<Failure, bool>> saveLoginCredentials({required UserModel user});
  Future<Either<Failure, UserModel?>> getSavedLoginCredentials();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, BaseResponse>> deleteAccount({
    required String accessToken,
  });
  Future<Either<Failure, BaseResponse>> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String accessToken,
  });
  Future<Either<Failure, BaseResponse>> forgetPassword({required String email});
}
