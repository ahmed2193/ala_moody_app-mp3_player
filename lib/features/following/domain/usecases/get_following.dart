import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/following_repository.dart';


class GetFollowing implements UseCase<BaseResponse, GetFollowingParams> {
  final FollowingRepository followingRepository;
  GetFollowing({required this.followingRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetFollowingParams params,
  ) =>
     followingRepository.getFollowing(
          accessToken: params.accessToken,
          pageNo: params.pageNo,
         );
}

class GetFollowingParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetFollowingParams(
      {required this.pageNo, required this.accessToken, });

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
