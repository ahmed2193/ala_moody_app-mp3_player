import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginWithMobileNumber
    implements UseCase<BaseResponse, LoginWithMobileNumberParams> {
  final AuthRepository authRepository;
  LoginWithMobileNumber({required this.authRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
          LoginWithMobileNumberParams params,) async =>
      authRepository.loginwiWthMobileNumber(
        phone: params.phone,
        mobileFlag: params.mobileFlag,
        userName: params.userName,
        fcmToken: params.fcmToken,
      );
}

class LoginWithMobileNumberParams extends Equatable {
  final String phone;
  final String mobileFlag;
  final String userName;
  final String fcmToken;
  const LoginWithMobileNumberParams({
    required this.phone,
    required this.mobileFlag,
    required this.userName,
    required this.fcmToken,
  });

  @override
  List<Object> get props => [
        phone,
        mobileFlag,
        userName,
        fcmToken,
      ];
}
