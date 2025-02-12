import 'package:alamoody/features/Playlists/domain/usecases/remove_song_from_playlists.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';

part 'remove_song_from_playlists_state.dart';

class RemoveSongFromPlaylistsCubit extends Cubit<RemoveSongFromPlaylistsState> {
  final RemoveSongFromPlaylists removeSongFromPlaylistsUseCase;

  RemoveSongFromPlaylistsCubit({
    required this.removeSongFromPlaylistsUseCase,
  }) : super(RemoveSongFromPlaylistsInitial());

  Future<void> removeSongFromPlaylists({
    required String accessToken,
    required int songId,
    required int playListsId,
  }) async {
    emit(RemoveSongFromPlaylistsLoading());
    final Either<Failure, BaseResponse> response =
        await removeSongFromPlaylistsUseCase.call(
      RemoveSongFromPlaylistsParams(
        songId: songId,
        accessToken: accessToken,
        playListsId: playListsId,
      ),
    );
    response.fold(
        (failure) =>
            emit(RemoveSongFromPlaylistsFailed(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(RemoveSongFromPlaylistsSuccess(message: response.message!));
      } else {
        emit(RemoveSongFromPlaylistsFailed(message: response.message!));
      }
    });
  }
}
