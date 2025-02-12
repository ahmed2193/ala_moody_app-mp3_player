import 'package:alamoody/features/live_stream/domain/repositories/live_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';

class GetLive implements UseCase<BaseResponse, GetLiveParams> {
  final LiveRepository liveRepository;
  GetLive({required this.liveRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetLiveParams params,
  ) =>
      liveRepository.getLiveUser(
          accessToken: params.accessToken,
          );
}

class GetLiveParams extends Equatable {
  final String accessToken;


  const GetLiveParams(
      { required this.accessToken, });

  @override
  List<Object?> get props => [
        accessToken,

      ];
}
