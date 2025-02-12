import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/exceptions.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/features/membership/data/datasources/plan_remote_datasource.dart';
import 'package:alamoody/features/membership/domain/repositories/plan_details_repository.dart';
import 'package:alamoody/features/membership/domain/usecases/coupon_code.dart';
import 'package:alamoody/features/membership/domain/usecases/direct_subscribe_to_plan_usecase.dart';
import 'package:alamoody/features/membership/domain/usecases/get_paln_usecase.dart';
import 'package:alamoody/features/membership/domain/usecases/subscribe_to_plan_usecase.dart';

import 'package:dartz/dartz.dart';

class PlanRepository extends BasePlanRepository {
  BasePlanRemoteDataSource basePlanRemoteDataSource;

  PlanRepository(this.basePlanRemoteDataSource);

  @override
  Future<Either<Failure, BaseResponse>> getPlanDetails({
    required GetPlanParams params,
  }) async {

    try {
          final res = await basePlanRemoteDataSource.getPlansData(params);

      return Right(res);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(message: failure.message),
      );
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> subscribeToPlan({
    required SubscribeToPlanParams params,
  }) async {

    try {
          final res = await basePlanRemoteDataSource.subscribeToPlan(params);

      return Right(res);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(message: failure.message),
      );
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> unsubscribePlan({
    required String accessToken,
  }) async {
    try {
      final response = await basePlanRemoteDataSource.unsubscribePlan(
        accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> directsubscribeToPlan({
    required DirectSubscribeToPlanParams params,
  }) async {

    try {
          final res = await basePlanRemoteDataSource.directsubscribeToPlan(params);

      return Right(res);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(message: failure.message),
      );
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> couponCode(
      {required CouponCodeParams params,}) async {

    try {
          final res = await basePlanRemoteDataSource.couponCode(params);

      return Right(res);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(message: failure.message),
      );
    }
  }
}
