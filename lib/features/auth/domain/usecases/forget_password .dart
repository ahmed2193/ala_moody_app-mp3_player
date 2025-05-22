import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgetPassword implements UseCase<BaseResponse, ForgetPasswordParams> {
  final AuthRepository authRepository;
  ForgetPassword({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
          ForgetPasswordParams params,) async =>
      authRepository.forgetPassword(
        email: params.email,
      );
}

class ForgetPasswordParams extends Equatable {
  final String email;

  const ForgetPasswordParams({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}
