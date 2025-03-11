import 'dart:io';

import 'package:alamoody/features/Playlists/presentation/cubits/create_edit_playlist/playlists_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../../home/domain/entities/Songs_PlayLists.dart';
import '../../../domain/usecases/edit_playlist.dart';

class EditPlaylistCubit extends Cubit<PlaylistState> {
  final EditPlaylist editPlaylistUseCase;

  EditPlaylistCubit({
    required this.editPlaylistUseCase,
  }) : super(PlaylistInitial());
  SongsPlayLists? playListsDetails;
  Future<void> editPlaylist({
    required String playlistId,
    required String playlistName,
    required String playlistDes,
    File? playlistImage,
    required String accessToken,
  }) async {
    emit(PlaylistLoading());

    final Either<Failure, BaseResponse> response =
        await editPlaylistUseCase.call(
      EditPlaylistParams(
        playlistId: playlistId,
        playlistName: playlistName,
        playlistDes: playlistDes,
        playlistImage: playlistImage,
        accessToken: accessToken,
      ),
    );
    response.fold((failure) => emit(PlaylistError(failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        playListsDetails = response.data;
        emit(PlaylistSuccess(response.message!));
      } else {
        emit(PlaylistError(response.message!));
      }
    });
  }
}
