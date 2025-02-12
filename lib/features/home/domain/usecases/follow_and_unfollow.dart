// Save Song on track play
// FollowAndUnFollow

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class FollowAndUnFollow
    implements UseCase<BaseResponse, FollowAndUnFollowParams> {
  final HomeRepository followAndUnFollowRepository;
  FollowAndUnFollow({required this.followAndUnFollowRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    FollowAndUnFollowParams params,
  ) async =>
      followAndUnFollowRepository.followAndUnFollow(
        type: params.type,
        id: params.id,
        accessToken: params.accessToken,
      );
}

class FollowAndUnFollowParams extends Equatable {
  final String type;
  final String id;
  final String accessToken;

  const FollowAndUnFollowParams({
    required this.type,
    required this.id,
    required this.accessToken,
  });

  @override
  List<Object> get props => [type, id, accessToken];
}
