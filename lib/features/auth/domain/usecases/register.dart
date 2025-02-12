import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class Register implements UseCase<BaseResponse, RegisterParams> {
  final AuthRepository authRepository;
  Register({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(RegisterParams params) async =>
      // ignore: unnecessary_await_in_return
      await authRepository.register(
        name: params.name,
        userName: params.userName,
        email: params.email,
        password: params.password,
      );
}

class RegisterParams extends Equatable {
  final String name;
  final String userName;
  final String email;
  final String password;

  const RegisterParams({
    required this.name,
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        name,
        userName,
        email,
        password,
      ];
}
