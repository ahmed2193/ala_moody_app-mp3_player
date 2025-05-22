// Save Song on track play
// CreatePlaylists

import 'dart:io';

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/Playlists/domain/repositories/playlists_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class CreatePlaylist implements UseCase<BaseResponse, CreatePlaylistParams> {
  final PlaylistsRepository playlistsRepository;
  CreatePlaylist({required this.playlistsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    CreatePlaylistParams params,
  ) async =>
      playlistsRepository.createPlaylist(
        params: params,
      );
}

class CreatePlaylistParams extends Equatable {
  final String playlistName;
  final String playlistDes;
  File? playlistImage;
  final String accessToken;

  CreatePlaylistParams({
    required this.playlistName,
    required this.playlistDes,
    required this.playlistImage,
    required this.accessToken,
  });

  @override
  List<Object> get props => [playlistName, accessToken , playlistImage!, playlistDes];
}
