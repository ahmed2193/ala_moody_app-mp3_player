import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/membership/domain/repositories/plan_details_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UnsubscribePlanUseCase
    extends UseCase<BaseResponse, UnsubscribePlanParams> {
  final BasePlanRepository basePlanRepository;

  UnsubscribePlanUseCase({required this.basePlanRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    UnsubscribePlanParams params,
  ) async {
    return basePlanRepository.unsubscribePlan(accessToken: params.accessToken);
  }
}

class UnsubscribePlanParams extends Equatable {
  final String accessToken;

  const UnsubscribePlanParams({
    required this.accessToken,
  });

  @override
  List<Object> get props => [
        accessToken,
      ];
}
