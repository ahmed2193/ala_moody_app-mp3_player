// Save Song on track play
// AddSongToPlaylists

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/Playlists/domain/repositories/playlists_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class AddSongToPlaylists
    implements UseCase<BaseResponse, AddSongToPlaylistsParams> {
  final PlaylistsRepository playlistsRepository;
  AddSongToPlaylists({required this.playlistsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    AddSongToPlaylistsParams params,
  ) async =>
      playlistsRepository.addSongToPlayLists(
        mediaId: params.mediaId,
        accessToken: params.accessToken,
        mediaType: params.mediaType,
        playListsId: params.playListsId,
      );
}

class AddSongToPlaylistsParams extends Equatable {
  final String accessToken;
  final int mediaId;
  final String mediaType;
  final int playListsId;

  const AddSongToPlaylistsParams({
    required this.accessToken,
    required this.mediaId,
    required this.playListsId,
    required this.mediaType,
  });

  @override
  List<Object> get props => [accessToken, mediaId, playListsId, mediaType];
}
