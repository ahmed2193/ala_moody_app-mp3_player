import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/library_remote_data_source.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource libraryRemoteDataSource;

  LibraryRepositoryImpl({
    required this.libraryRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getLibrary({
    required String accessToken,
    required String type,
    required int pageNo,
  }) async {
    try {
      final response = await libraryRemoteDataSource.getLibrary(
          accessToken: accessToken, pageNo: pageNo, type: type,);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
