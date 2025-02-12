import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/playlists_repository.dart';
import '../datasources/playlists_remote_data_source.dart';

class PlayListsRepositoryImpl implements PlaylistsRepository {
  final PlayListsRemoteDataSource playListsRemoteDataSource;

  PlayListsRepositoryImpl({
    required this.playListsRemoteDataSource,
  });

  @override
  Future<Either<Failure, BaseResponse>> addSongToPlayLists(
      {required String accessToken,
      required int mediaId,
      required String mediaType,
      required int playListsId,}) async {
    try {
      final response = await playListsRemoteDataSource.addSongToPlayLists(
        mediaId: mediaId,
        accessToken: accessToken,
        mediaType: mediaType,
        playListsId: playListsId,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> createPlaylists(
      {required String accessToken, required String playlistName,}) async {
    try {
      final response = await playListsRemoteDataSource.createPlaylists(
        playlistName: playlistName,
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getMyplayLists(
      {required String accessToken, required int pageNo,}) async {
    try {
      final response = await playListsRemoteDataSource.getMyplayLists(
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> removeSongFromPlayLists(
      {required String accessToken,
      required int songId,
      required int playListsId,}) async {
    try {
      final response = await playListsRemoteDataSource.removeSongFromPlayLists(
        songId: songId,
        accessToken: accessToken,
        playListsId: playListsId,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
