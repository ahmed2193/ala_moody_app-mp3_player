import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<BaseResponse, LoginParams> {
  final AuthRepository authRepository;
  Login({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(LoginParams params) async =>
      authRepository.login(
        email: params.email,
        password: params.password,
        fcmToken: params.fcmToken,
      );
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  final String fcmToken;

  const LoginParams({
    required this.email,
    required this.password,
    required this.fcmToken,
  });

  @override
  List<Object> get props => [
        email,
        password,
        fcmToken,
      ];
}
