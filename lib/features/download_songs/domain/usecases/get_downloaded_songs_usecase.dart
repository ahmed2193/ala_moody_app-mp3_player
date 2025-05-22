import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/download_songs/data/models/downloaded_song_model.dart';
import 'package:alamoody/features/download_songs/domain/repositories/base_download_repository.dart';
import 'package:dartz/dartz.dart';

class GetDownloadedMusicUseCase
    implements UseCase<List<DownloadedMusicModel>, NoParams> {
  final BaseDownloadRepository baseDownloadRepository;
  GetDownloadedMusicUseCase({required this.baseDownloadRepository});

  @override
  Future<Either<Failure, List<DownloadedMusicModel>>> call(
          NoParams noParams,) async =>
      baseDownloadRepository.getDownloadedMusic();
}
