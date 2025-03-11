// Save Song on track play
// removePlaylist

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/Playlists/domain/repositories/playlists_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class RemovePlaylist implements UseCase<BaseResponse, RemovePlaylistParams> {
  final PlaylistsRepository playlistsRepository;
  RemovePlaylist({required this.playlistsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    RemovePlaylistParams params,
  ) async =>
      playlistsRepository.removePlaylist(
        params: params,
      );
}

class RemovePlaylistParams extends Equatable {
  final String playlistId;
  final String accessToken;

  const RemovePlaylistParams({
    required this.playlistId,
    required this.accessToken,
  });

  @override
  List<Object> get props => [playlistId, accessToken];
}
