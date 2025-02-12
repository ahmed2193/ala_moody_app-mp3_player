import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class DeleteAccount implements UseCase<BaseResponse, DeleteAccountParams> {
  final AuthRepository authRepository;
  DeleteAccount({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
          DeleteAccountParams params,) async =>
      authRepository.deleteAccount(
    
        accessToken: params.accessToken,
      );
}

class DeleteAccountParams extends Equatable {

  final String accessToken;

  const DeleteAccountParams({

    required this.accessToken,
  });

  @override
  List<Object> get props => [ accessToken];
}
