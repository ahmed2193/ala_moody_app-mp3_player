import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterWithMobileNumber
    implements UseCase<BaseResponse, RegisterWithMobileNumberParams> {
  final AuthRepository authRepository;
  RegisterWithMobileNumber({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    RegisterWithMobileNumberParams params,
  ) async =>
      authRepository.registerWithMobileNumber(
        phone: params.phone,
        mobileFlag: params.mobileFlag,
        userName: params.userName,
      );
}

class RegisterWithMobileNumberParams extends Equatable {
  final String phone;
  final String mobileFlag;
  final String userName;
  const RegisterWithMobileNumberParams({
    required this.phone,
    required this.mobileFlag,
    required this.userName,
  });

  @override
  List<Object> get props => [
        phone,
        mobileFlag,
        userName,
      ];
}
