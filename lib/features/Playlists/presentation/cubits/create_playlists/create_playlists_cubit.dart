import 'package:alamoody/features/Playlists/domain/usecases/create_playlists.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';

part 'create_playlists_state.dart';

class CreatePlaylistsCubit extends Cubit<CreatePlaylistsState> {
  final CreatePlaylists createPlaylistsUseCase;

  CreatePlaylistsCubit({
    required this.createPlaylistsUseCase,
  }) : super(CreatePlaylistsInitial());

  Future<void> createPlaylists({
    required String playlistName,
    required String accessToken,
  }) async {
    emit(CreatePlaylistsLoading());

    final Either<Failure, BaseResponse> response =
        await createPlaylistsUseCase.call(
      CreatePlaylistsParams(
        accessToken: accessToken,
        playlistName: playlistName,
      ),
    );
    response.fold(
        (failure) => emit(CreatePlaylistsFailed(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(CreatePlaylistsSuccess(message: response.message!));
      } else {
        emit(CreatePlaylistsFailed(message: response.message!));
      }
    });
  }
}
