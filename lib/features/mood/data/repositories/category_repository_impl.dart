import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/mood_remote_data_source.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDataSource moodRemoteDataSource;

  MoodRepositoryImpl({
    required this.moodRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getMood({
    required String accessToken,
  }) async {
    try {
      final response = await moodRemoteDataSource.getMood(
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getMoodsongs(
      {required String accessToken,
      required int id,
      required int pageNo,}) async {
    try {
      final response = await moodRemoteDataSource.getMoodsongs(
          accessToken: accessToken, id: id, pageNo: pageNo,);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
