import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl({
    required this.homeRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getplayLists({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await homeRemoteDataSource.getplayLists(
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getPopularSongs({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await homeRemoteDataSource.getPopularSongs(
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getRecentListen({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await homeRemoteDataSource.getRecentListen(
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> saveSongOnTrackPlay({
    required String type,
    required String id,
    required String accessToken,
  }) async {
    try {
      final response = await homeRemoteDataSource.saveSongOnTrackPlay(
        type: type,
        id: id,
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
  
  @override
  Future<Either<Failure, BaseResponse>> getArtistDetails({required String accessToken, required int id, required int pageNo}) async {
    try {
      final response = await homeRemoteDataSource.getArtistDetails(
        id: id,
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
  
  @override
  Future<Either<Failure, BaseResponse>> getArtists({required String accessToken, required int pageNo})  async {
    try {
      final response = await homeRemoteDataSource.getArtists(
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
    @override
  Future<Either<Failure, BaseResponse>> followAndUnFollow({
    required String type,
    required String id,
    required String accessToken,
  }) async {
    try {
      final response = await homeRemoteDataSource.followAndUnFollow(
        type: type,
        id: id,
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
    @override
  Future<Either<Failure, BaseResponse>> homeData(
      {required String accessToken, required String searchTxt,}) async {
    try {
      final response = await homeRemoteDataSource.homeData(
        accessToken: accessToken,
        searchText: searchTxt,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
   @override
  Future<Either<Failure, BaseResponse>> setRingtones({

    required String accessToken,
  }) async {
    try {
      final response = await homeRemoteDataSource.setRingtones(

        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
  
}
