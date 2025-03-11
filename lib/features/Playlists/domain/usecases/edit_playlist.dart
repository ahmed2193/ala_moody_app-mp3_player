// Save Song on track play
// editPlaylists

import 'dart:io';

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/Playlists/domain/repositories/playlists_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class EditPlaylist implements UseCase<BaseResponse, EditPlaylistParams> {
  final PlaylistsRepository playlistsRepository;
  EditPlaylist({required this.playlistsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    EditPlaylistParams params,
  ) async =>
      playlistsRepository.editPlaylist(
        params: params,
      );
}

class EditPlaylistParams extends Equatable {
  final String playlistId;
  final String playlistName;
  final String playlistDes;
  File? playlistImage;
  final String accessToken;

  EditPlaylistParams({
    required this.playlistId,
    required this.playlistName,
    required this.playlistDes,
    this.playlistImage,
    required this.accessToken,
  });

  @override
  List<Object> get props =>
      [playlistName, playlistId, accessToken, playlistImage!, playlistDes];
}
