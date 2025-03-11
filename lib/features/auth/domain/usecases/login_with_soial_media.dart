import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginWithSoialMedia
    implements UseCase<BaseResponse, LoginWithSoialMediaParams> {
  final AuthRepository authRepository;
  LoginWithSoialMedia({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
          LoginWithSoialMediaParams params,) async =>
      authRepository.loginWithSocialMedia(
          displayName: params.displayName,
          email: params.email,
          isGoogle: params.isGoogle,
          socialId: params.socialId,
          fcmToken: params.fcmToken,
          );
}

class LoginWithSoialMediaParams extends Equatable {
  final String email;
  final int isGoogle;
  final String displayName;
  final String socialId;
  final String fcmToken;
  const LoginWithSoialMediaParams({
    required this.email,
    required this.isGoogle,
    required this.displayName,
    required this.socialId,
    required this.fcmToken,
  });

  @override
  List<Object> get props => [
        email,
        isGoogle,
        displayName,
        socialId,
        fcmToken,
      ];
}
