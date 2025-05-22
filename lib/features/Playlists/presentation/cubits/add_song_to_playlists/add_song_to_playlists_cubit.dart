import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/add_song_to_playlists.dart';

part 'add_song_to_playlists_state.dart';

class AddSongToPlaylistsCubit extends Cubit<AddSongToPlaylistsState> {
  final AddSongToPlaylists addSongToPlaylistsUseCase;

  AddSongToPlaylistsCubit({
    required this.addSongToPlaylistsUseCase,
  }) : super(AddSongToPlaylistsInitial());

  Future<void> addSongToPlaylists({
    required String accessToken,
    required int mediaId,
    required String mediaType,
    required int playListsId,
  }) async {
    final Either<Failure, BaseResponse> response =
        await addSongToPlaylistsUseCase.call(
      AddSongToPlaylistsParams(
        mediaId: mediaId,
        accessToken: accessToken,
        mediaType: mediaType,
        playListsId: playListsId,
      ),
    );
    response.fold(
        (failure) => emit(AddSongToPlaylistsFailed(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(AddSongToPlaylistsSuccess(message: response.message!));
      } else {
        emit(AddSongToPlaylistsFailed(message: response.message!));
      }
    });
  }
}
