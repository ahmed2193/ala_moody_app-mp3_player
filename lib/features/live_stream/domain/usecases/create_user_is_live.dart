import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/live_repository.dart';

class CreateUserIsLive implements UseCase<BaseResponse, CreateUserIsLiveParams> {
  final LiveRepository liveRepository;
  CreateUserIsLive({required this.liveRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    CreateUserIsLiveParams params,
  ) =>
      liveRepository.creatUserIsLive(
          accessToken: params.accessToken,
          isLive: params.isLive,
          );
}

class CreateUserIsLiveParams extends Equatable {
  final String accessToken;
  final String isLive;


  const CreateUserIsLiveParams(
      { required this.accessToken, required this.isLive,  });

  @override
  List<Object?> get props => [
        accessToken,
        isLive,
      ];
}
