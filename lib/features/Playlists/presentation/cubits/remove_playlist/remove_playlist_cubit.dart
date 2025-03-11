import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/remove_playlist.dart';

part 'remove_playlist_state.dart';

class RemovePlaylistCubit extends Cubit<RemovePlaylistState> {
  final RemovePlaylist removePlaylistUseCase;

  RemovePlaylistCubit({
    required this.removePlaylistUseCase,
  }) : super(RemovePlaylistInitial());

  Future<void> removePlaylist({
    required String accessToken,
    required String playListsId,
  }) async {
    emit(RemovePlaylistLoading());
    final Either<Failure, BaseResponse> response =
        await removePlaylistUseCase.call(
      RemovePlaylistParams(
        playlistId: playListsId,
        accessToken: accessToken,
      ),
    );
    response.fold(
        (failure) => emit(RemovePlaylistFailed(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(RemovePlaylistSuccess(message: response.message!));
      } else {
        emit(RemovePlaylistFailed(message: response.message!));
      }
    });
  }
}
