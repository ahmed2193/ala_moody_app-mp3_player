import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPassword implements UseCase<BaseResponse, ResetPasswordParams> {
  final AuthRepository authRepository;
  ResetPassword({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
          ResetPasswordParams params,) async =>
      authRepository.resetPassword(
        oldPassword: params.oldPassword,
        newPassword: params.newPassword,
        accessToken: params.accessToken,
      );
}

class ResetPasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;
  final String accessToken;

  const ResetPasswordParams({
    required this.oldPassword,
    required this.newPassword,
    required this.accessToken,
  });

  @override
  List<Object> get props => [oldPassword, newPassword, accessToken];
}
