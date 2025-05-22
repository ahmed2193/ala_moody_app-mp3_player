import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_remote_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource favoriteRemoteDataSource;

  FavoriteRepositoryImpl({
    required this.favoriteRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getFavorite({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await favoriteRemoteDataSource.getFavorite(
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
  

    @override
  Future<Either<Failure, BaseResponse>> addAndRemoveFromFavorites({
    required String type,
    required String id,
    required String accessToken,
  }) async {
    try {
      final response = await favoriteRemoteDataSource.addAndRemoveFromFavorites(
        type: type,
        id: id,
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
