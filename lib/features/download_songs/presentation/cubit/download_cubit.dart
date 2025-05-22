import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/entities/songs.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/app_strings.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/download_songs/data/models/downloaded_song_model.dart';
import 'package:alamoody/features/download_songs/domain/usecases/download_usecase.dart';
import 'package:alamoody/features/download_songs/domain/usecases/get_downloaded_songs_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit({
    required this.downloadUseCase,
    required this.getDownloadedMusicUseCase,
  }) : super(DownloadListInitial());

  final DownloadUseCase downloadUseCase;
  final GetDownloadedMusicUseCase getDownloadedMusicUseCase;

  final List<DownloadedMusicModel> downloadedMusicList =
      []; // ✅ Store full objects
  final Map<int, double> downloadProgress =
      {}; // ✅ Track progress for each song
        final List<Songs> downloadingSongs = []; // ✅ Store downloading songs

  /// **Start Download**
  Future<void> download(
      {required Songs song, required BuildContext context,}) async {
    if (isDownloaded(song.id) || isDownloading(song.id)) return;

    downloadProgress[song.id] = 0.0;
    downloadingSongs.add(song); // ✅ Add to downloading list
    emit(DownloadingListUpdated(
        songs: List.from(downloadingSongs),),); // ✅ Emit updated list

    Constants.showToast(
      message: AppLocalizations.of(context)!.translate("downloadStarted")!,
    );

    final response = await downloadUseCase.call(
      DownloadParams(
        song: song,
        songsList: downloadedMusicList,
        onProgress: (double progress) {
          downloadProgress[song.id] = progress;
          emit(DownloadingProgress(id: song.id, progress: progress));
          emit(DownloadingListUpdated(
              songs: List.from(downloadingSongs),),); // ✅ Update list
        },
      ),
    );

    downloadingSongs.removeWhere((s) => s.id == song.id); // ✅ Remove from list
    downloadProgress.remove(song.id);
    emit(DownloadingListUpdated(
        songs: List.from(downloadingSongs),),); // ✅ Emit updated list

    response.fold(
      (failure) {
        emit(DownloadListError(message: _mapFailureToMsg(failure)));
      },
      (data) {
        emit(Downloaded(id: song.id));
        Constants.showToast(
          message:
              AppLocalizations.of(context)!.translate("downloadCompleted")!,
        );
      },
    );
  }

  // /// **Start Download**


  /// **Get Downloaded Songs**
Future<void> getSavedDownloads() async {
  emit(DownloadListLoading());
  final response = await getDownloadedMusicUseCase.call(NoParams());

  response.fold(
    (failure) => emit(DownloadListError(message: _mapFailureToMsg(failure))),
    (data) {
      downloadedMusicList
        ..clear()
        ..addAll(data);

      // ✅ Ensure sorting considers full date & time (YYYY-MM-DD HH:mm:ss)
      downloadedMusicList.sort((a, b) {
        final DateTime dateA = DateTime.parse(a.date!); // Parse full date-time
        final DateTime dateB = DateTime.parse(b.date!);
        return dateB.compareTo(dateA); // Sort descending (latest first)
      });

      emit(const DownloadListLoaded());
    },
  );
}

  /// **Check if Downloading**
  bool isDownloading(int id) => downloadProgress.containsKey(id);

  /// **Get Progress for a Song**
  double getProgress(int id) => downloadProgress[id] ?? 0.0;

  /// **Check if Already Downloaded**
  bool isDownloaded(int id) => downloadedMusicList.any((song) => song.id == id);
  List<Songs> getDownloadingSongs() => downloadingSongs;
  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure;
      case CacheFailure:
        return AppStrings.cacheFailure;
      default:
        return AppStrings.unexpectedError;
    }
  }
}
