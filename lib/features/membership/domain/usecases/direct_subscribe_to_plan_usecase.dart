import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/membership/domain/repositories/plan_details_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DirectSubscribeToPlanUseCase
    extends UseCase<BaseResponse, DirectSubscribeToPlanParams> {
  final BasePlanRepository basePlanRepository;

  DirectSubscribeToPlanUseCase({required this.basePlanRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
      DirectSubscribeToPlanParams params,) async {
    return basePlanRepository.directsubscribeToPlan(params: params);
  }
}

class DirectSubscribeToPlanParams extends Equatable {
  final String accessToken;
  final String planId;

  const DirectSubscribeToPlanParams({
    required this.accessToken,
    required this.planId,
  });

  @override
  List<Object> get props => [accessToken, planId];
}
