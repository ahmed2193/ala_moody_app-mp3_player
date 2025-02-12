// import 'package:alamoody/core/error/failures.dart';
// import 'package:alamoody/core/utils/usecases/usecase.dart';
// import 'package:alamoody/features/download_songs/data/models/downloaded_song_model.dart';
// import 'package:alamoody/features/download_songs/domain/repositories/base_download_repository.dart';
//
// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
//
// class SaveDownloadedMusicUseCase
//     implements UseCase<bool, SaveDownloadedMusicParams> {
//   final BaseDownloadRepository baseDownloadRepository;
//   SaveDownloadedMusicUseCase({required this.baseDownloadRepository});
//
//   @override
//   Future<Either<Failure, bool>> call(SaveDownloadedMusicParams params) async =>
//       await baseDownloadRepository.saveDownloadSong(
//         params: params,
//       );
// }
//
// class SaveDownloadedMusicParams extends Equatable {
//   final List<DownloadedMusicModel> downloadedMusic;
//
//   const SaveDownloadedMusicParams({
//     required this.downloadedMusic,
//   });
//
//   @override
//   List<Object> get props => [
//         downloadedMusic,
//       ];
// }
