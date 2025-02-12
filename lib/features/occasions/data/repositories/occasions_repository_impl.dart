import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/occasions_repository.dart';
import '../datasources/occasions_remote_data_source.dart';

class OccasionsRepositoryImpl implements OccasionsRepository {
  final OccasionsRemoteDataSource occasionsRemoteDataSource;

  OccasionsRepositoryImpl({
    required this.occasionsRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getOccasions({
    required String accessToken,
    required String id,
    required String txt,
    required int pageNo,
  }) async {
    try {
      final response = await occasionsRemoteDataSource.getOccasions(
          accessToken: accessToken, pageNo: pageNo, id: id,txt:txt,);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
