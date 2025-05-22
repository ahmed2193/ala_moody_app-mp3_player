import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/radio_repository.dart';
import '../datasources/radio_remote_data_source.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioRemoteDataSource radioRemoteDataSource;

  RadioRepositoryImpl({
    required this.radioRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getRadio({
    required String accessToken,
  }) async {
    try {
      final response = await radioRemoteDataSource.getRadio(
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getRadioCategories({
    required String accessToken,
    required int id,
  }) async {
    try {
      final response = await radioRemoteDataSource.getRadioCategories(
        accessToken: accessToken,
        id: id,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
