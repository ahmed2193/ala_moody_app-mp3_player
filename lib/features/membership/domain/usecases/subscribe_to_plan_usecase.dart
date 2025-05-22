import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/membership/domain/repositories/plan_details_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SubscribeToPlanUseCase
    extends UseCase<BaseResponse, SubscribeToPlanParams> {
  final BasePlanRepository basePlanRepository;

  SubscribeToPlanUseCase({required this.basePlanRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
      SubscribeToPlanParams params,) async {
    return basePlanRepository.subscribeToPlan(params: params);
  }
}

class SubscribeToPlanParams extends Equatable {
  final String accessToken;
  final String planId;
  final String? couponCode;

  const SubscribeToPlanParams({
    required this.accessToken,
    required this.planId,
    required this.couponCode,
  });

  @override
  List<Object> get props => [accessToken, planId ,couponCode!];
}
