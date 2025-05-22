import 'package:alamoody/core/entities/songs.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/download_songs/data/models/downloaded_song_model.dart';
import 'package:alamoody/features/download_songs/domain/repositories/base_download_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DownloadUseCase extends UseCase<void, DownloadParams> {
  final BaseDownloadRepository baseDownloadRepository;

  DownloadUseCase({required this.baseDownloadRepository});

  @override
  Future<Either<Failure, void>> call(
    DownloadParams params,
  ) async {
    return baseDownloadRepository.downloadSong(
      params: params,
    );
  }
}

class DownloadParams extends Equatable {
  final Songs song;
  final List<DownloadedMusicModel> songsList;
  Function(double) onProgress;
   DownloadParams({
    required this.song,
    required this.songsList,
  required   this.onProgress,
  });

  @override
  List<Object> get props => [song, songsList ,onProgress];
}
