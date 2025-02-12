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
    // required this.saveDownloadedMusicUseCase,
    required this.getDownloadedMusicUseCase,
  }) : super(DownloadListInitial());

  final DownloadUseCase downloadUseCase;
  // final SaveDownloadedMusicUseCase saveDownloadedMusicUseCase;
  final GetDownloadedMusicUseCase getDownloadedMusicUseCase;

  bool isLoading = false;
  bool isDownloaded = false;
  int? downloadId = -11;
  List<DownloadedMusicModel> downloadedMusicList = [];
  double progress=0.0;
  void changeLoadingView() {
    isLoading = !isLoading;
    emit(DownloadListLoading());
  }

  dynamic Function(double)? onProgress;
  Future<void> download({
    required Songs song,
    required BuildContext context,
  }) async {
    Constants.showToast(
      message: AppLocalizations.of(context)!.translate("downloadStarted")!,
    );

    emit(Downloading(id: song.id));
    downloadId = song.id;

    final response = await downloadUseCase.call(
      DownloadParams(
        song: song,
        songsList: downloadedMusicList,
        onProgress: (double progress) {
          // ✅ Handle progress updates
          progress = progress;
          emit(DownloadingProgress(id: song.id, progress: progress));
        },
      ),
    );

    emit(
      response.fold(
        (failure) => DownloadListError(message: _mapFailureToMsg(failure)),
        (data) {
          Constants.showToast(
            message:
                AppLocalizations.of(context)!.translate("downloadCompleted")!,
          );
          isDownloaded = true;
          downloadId = -11;
          return Downloaded();
        },
      ),
    );
  }

  // Future<void> saveDownloads() async {
  //   final response = await saveDownloadedMusicUseCase
  //       .call(SaveDownloadedMusicParams(downloadedMusic: downloadedMusicList));
  //   response.fold(
  //     (failure) => DownloadListError(message: _mapFailureToMsg(failure)),
  //     (data) {
  //       return DownloadListSaved();
  //     },
  //   );
  // }

  Future<void> getSavedDownloads() async {
    changeLoadingView();
    final response = await getDownloadedMusicUseCase.call(NoParams());
    emit(
      response.fold(
        (failure) => DownloadListError(message: _mapFailureToMsg(failure)),
        (data) {
          downloadedMusicList = data;
          return const DownloadListLoaded();
        },
      ),
    );
  }

  void isDownload(int id) {
    final DownloadedMusicModel song;

    song = downloadedMusicList.firstWhere(
      (element) => element.id == id,
      orElse: () => DownloadedMusicModel(id: -11),
    );
    isDownloaded = song.id != -11;
    emit(IsDownloadedLoaded());
  }

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
