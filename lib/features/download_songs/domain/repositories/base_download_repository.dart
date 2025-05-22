import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/features/download_songs/data/models/downloaded_song_model.dart';
import 'package:alamoody/features/download_songs/domain/usecases/download_usecase.dart';

import 'package:dartz/dartz.dart';

abstract class BaseDownloadRepository {
  // Future<Either<Failure, BaseResponse>> getProjectDetails({
  //   required GetProjectDetailsParams params,
  // });

  Future<Either<Failure, void>> downloadSong({
    required DownloadParams params,
  });
  // Future<Either<Failure, bool>> saveDownloadSong({
  //   required SaveDownloadedMusicParams params,
  // });
  Future<Either<Failure, List<DownloadedMusicModel>>> getDownloadedMusic();
}
