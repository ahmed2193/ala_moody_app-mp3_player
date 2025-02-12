import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/discover_repository.dart';
import '../datasources/discover_remote_data_source.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  final DiscoverRemoteDataSource discoverRemoteDataSource;

  DiscoverRepositoryImpl({
    required this.discoverRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getDiscover({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await discoverRemoteDataSource.getDiscover(
          accessToken: accessToken, pageNo: pageNo, );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
