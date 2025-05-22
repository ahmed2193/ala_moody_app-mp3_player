import 'package:alamoody/core/error/exceptions.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/features/download_songs/data/local_datasource/local_data_source.dart';
import 'package:alamoody/features/download_songs/data/models/downloaded_song_model.dart';
import 'package:alamoody/features/download_songs/data/remote_datasources/download_remote_datasource.dart';
import 'package:alamoody/features/download_songs/domain/repositories/base_download_repository.dart';
import 'package:alamoody/features/download_songs/domain/usecases/download_usecase.dart';

import 'package:dartz/dartz.dart';

class DownloadRepository extends BaseDownloadRepository {
  BaseDownloadDataSource baseDownloadDataSource;
  BaseDownloadedLocalDataSource baseDownloadedLocalDataSource;

  DownloadRepository(
      this.baseDownloadDataSource, this.baseDownloadedLocalDataSource,);

  @override
  Future<Either<Failure, void>> downloadSong({
    required DownloadParams params,
  }) async {
    final res = await baseDownloadDataSource.downloadSongs(
      params,
    );

    try {
      return Right(res);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(message: failure.message),
      );
    }
  }

  @override
  Future<Either<Failure, List<DownloadedMusicModel>>>
      getDownloadedMusic() async {
    try {
      final response = await baseDownloadedLocalDataSource.getDownloadedMusic();
      return Right(response);
    } on CacheException {
      return const Left(CacheFailure(message: 'Cache Error'));
    }
  }

  // @override
  // Future<Either<Failure, bool>> saveDownloadSong(
  //     {required SaveDownloadedMusicParams params}) async {
  //   try {
  //     final response = await baseDownloadedLocalDataSource.saveDownloadedMusic(
  //         savedMusic: params.downloadedMusic);
  //     return Right(response);
  //   } on CacheException {
  //     return const Left(CacheFailure(message: 'Cache Error'));
  //   }
  // }
}
