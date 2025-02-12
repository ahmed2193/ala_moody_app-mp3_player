// Save Song on track play
// CreatePlaylists

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/Playlists/domain/repositories/playlists_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class CreatePlaylists
    implements UseCase<BaseResponse, CreatePlaylistsParams> {
  final PlaylistsRepository playlistsRepository;
  CreatePlaylists({required this.playlistsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    CreatePlaylistsParams params,
  ) async =>
      playlistsRepository.createPlaylists(
        playlistName: params.playlistName,
        accessToken: params.accessToken,
      );
}

class CreatePlaylistsParams extends Equatable {
  final String playlistName;
  final String accessToken;

  const CreatePlaylistsParams({
    required this.playlistName,
    required this.accessToken,
  });

  @override
  List<Object> get props => [playlistName, accessToken];
}
