import 'dart:io';

import 'package:alamoody/features/Playlists/domain/usecases/create_playlist.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/create_edit_playlist/playlists_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';

class CreatePlaylistCubit extends Cubit<PlaylistState> {
  final CreatePlaylist createPlaylistUseCase;

  CreatePlaylistCubit({
    required this.createPlaylistUseCase,
  }) : super(PlaylistInitial());

  Future<void> createPlaylist({
    required String playlistName,
    required String playlistDes,
    File? playlistImage,
    required String accessToken,
  }) async {
    emit(PlaylistLoading());

    final Either<Failure, BaseResponse> response =
        await createPlaylistUseCase.call(
      CreatePlaylistParams(
        playlistName: playlistName,
        playlistDes: playlistDes,
        playlistImage: playlistImage,
        accessToken: accessToken,
      ),
    );
    response.fold((failure) => emit(PlaylistError(failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(PlaylistSuccess(response.message!));
      } else {
        emit(PlaylistError(response.message!));
      }
    });
  }
}
