import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource searchRemoteDataSource;

  SearchRepositoryImpl({
    required this.searchRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getCategory({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await searchRemoteDataSource.getCategory(
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> search(
      {required String accessToken, required String searchTxt,}) async {
    try {
      final response = await searchRemoteDataSource.search(
        accessToken: accessToken,
        searchText: searchTxt,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
