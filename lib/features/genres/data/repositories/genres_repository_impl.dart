import 'package:alamoody/features/genres/data/datasources/occasions_remote_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/genres_repository.dart';

class GenresRepositoryImpl implements GenresRepository {
  final GenresRemoteDataSource genresRemoteDataSource;

  GenresRepositoryImpl({
    required this.genresRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getGenres({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await genresRemoteDataSource.getGenres(
          accessToken: accessToken, pageNo: pageNo, );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
