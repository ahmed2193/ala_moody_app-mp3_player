import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/save_song_on_track_play.dart';

part 'save_song_on_track_play_state.dart';

class SaveSongOnTrackPlayCubit extends Cubit<SaveSongOnTrackPlayState> {
  final SaveSongOnTrackPlay saveSongOnTrackPlayUseCase;

  SaveSongOnTrackPlayCubit({
    required this.saveSongOnTrackPlayUseCase,
  }) : super(SaveSongOnTrackPlayInitial());

  Future<void> saveSongOnTrackPlay({
    required String id,
    required String type,
    required String accessToken,
  }) async {
    emit(SaveSongOnTrackPlayLoading());
    final Either<Failure, BaseResponse> response =
        await saveSongOnTrackPlayUseCase.call(
      SaveSongOnTrackPlayParams(
        accessToken: accessToken,
        id: id,
        type: type,
      ),
    );
    response.fold(
        (failure) => emit(SaveSongOnTrackPlayFailed(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(SaveSongOnTrackPlaySuccess(message: response.message!));
      } else {
        emit(SaveSongOnTrackPlayFailed(message: response.message!));
      }
    });
  }
}
