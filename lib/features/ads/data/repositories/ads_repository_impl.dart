import 'package:alamoody/features/ads/data/datasources/ads_remote_data_source.dart';
import 'package:alamoody/features/ads/domain/repositories/ads_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource adsRemoteDataSource;

  AdsRepositoryImpl({
    required this.adsRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getAds(

  ) async {
    try {
      final response = await adsRemoteDataSource.getAds(
           );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
