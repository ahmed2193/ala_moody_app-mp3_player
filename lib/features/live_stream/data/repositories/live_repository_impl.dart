import 'package:alamoody/features/live_stream/data/datasources/live_remote_data_source.dart';
import 'package:alamoody/features/live_stream/domain/repositories/live_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class LiveRepositoryImpl implements LiveRepository {
  final LiveRemoteDataSource liveRemoteDataSource;

  LiveRepositoryImpl({
    required this.liveRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getLiveUser({
    required String accessToken,
  }) async {
    try {
      final response = await liveRemoteDataSource.getLiveUser(
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> creatUserIsLive({
    required String accessToken,
    required String isLive,
  }) async {
    try {
      final response = await liveRemoteDataSource.creatUserIsLive(
        accessToken: accessToken,
        isLive: isLive,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
  

}
