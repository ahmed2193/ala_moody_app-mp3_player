import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/auth/domain/repositories/auth_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateTokenUseCase implements UseCase<BaseResponse, UpdateTokenParams> {
  final AuthRepository authRepository;

  UpdateTokenUseCase({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(UpdateTokenParams params) async =>
      authRepository.updateDeviceToken(
        params: params,
      );
}

class UpdateTokenParams extends Equatable {
  final String token;
  final String accessToken;

  const UpdateTokenParams({
    required this.token,
    required this.accessToken,
  });

  @override
  List<Object> get props => [
        token,
    accessToken,
      ];
}
