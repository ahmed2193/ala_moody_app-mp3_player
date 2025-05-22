// Save Song on track play
// RemoveSongFromPlaylists

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/Playlists/domain/repositories/playlists_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class RemoveSongFromPlaylists
    implements UseCase<BaseResponse, RemoveSongFromPlaylistsParams> {
  final PlaylistsRepository playlistsRepository;
  RemoveSongFromPlaylists({required this.playlistsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    RemoveSongFromPlaylistsParams params,
  ) async =>
      playlistsRepository.removeSongFromPlayLists(
        songId: params.songId,
        accessToken: params.accessToken,
        playListsId: params.playListsId,
      );
}

class RemoveSongFromPlaylistsParams extends Equatable {
  final String accessToken;
  final int songId;
  final int playListsId;

  const RemoveSongFromPlaylistsParams({
    required this.accessToken,
    required this.songId,
    required this.playListsId,
  });

  @override
  List<Object> get props => [
        accessToken,
        songId,
        playListsId,
      ];
}
