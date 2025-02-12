import 'package:alamoody/features/following/data/datasources/following_remote_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/following_repository.dart';

class FollowingRepositoryImpl implements FollowingRepository {
  final FollowingRemoteDataSource followingRemoteDataSource;

  FollowingRepositoryImpl({
    required this.followingRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getFollowing({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await followingRemoteDataSource.getFollowing(
          accessToken: accessToken, pageNo: pageNo, );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
