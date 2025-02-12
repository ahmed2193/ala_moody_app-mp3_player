import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/features/membership/domain/usecases/get_paln_usecase.dart';
import 'package:alamoody/features/membership/domain/usecases/subscribe_to_plan_usecase.dart';
import 'package:dartz/dartz.dart';

import '../usecases/coupon_code.dart';
import '../usecases/direct_subscribe_to_plan_usecase.dart';

abstract class BasePlanRepository {
  Future<Either<Failure, BaseResponse>> getPlanDetails({
    required GetPlanParams params,
  });

  Future<Either<Failure, BaseResponse>> subscribeToPlan({
    required SubscribeToPlanParams params,
  });
  Future<Either<Failure, BaseResponse>> directsubscribeToPlan({
    required DirectSubscribeToPlanParams params,
  });
  Future<Either<Failure, BaseResponse>> unsubscribePlan({
    required String accessToken,
  });

  Future<Either<Failure, BaseResponse>> couponCode({
    required CouponCodeParams params,
  });
}
