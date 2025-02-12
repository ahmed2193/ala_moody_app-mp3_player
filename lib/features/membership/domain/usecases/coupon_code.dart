import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/membership/domain/repositories/plan_details_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CouponCodeUseCase extends UseCase<BaseResponse, CouponCodeParams> {
  final BasePlanRepository basePlanRepository;

  CouponCodeUseCase({required this.basePlanRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    CouponCodeParams params,
  ) async {
    return basePlanRepository.couponCode(params: params);
  }
}

class CouponCodeParams extends Equatable {
  final String accessToken;
  final String planId;
  final String coupon;

  const CouponCodeParams({
    required this.accessToken,
    required this.planId,
    required this.coupon,
  });

  @override
  List<Object> get props => [accessToken, planId, coupon];
}
