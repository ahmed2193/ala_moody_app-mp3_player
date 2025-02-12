import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/audio_playlists_repository.dart';

class GetAudioPlaylists
    implements UseCase<BaseResponse, GetAudioPlaylistsParams> {
  final AudioPlaylistsRepository audioPlaylistsRepository;
  GetAudioPlaylists({required this.audioPlaylistsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetAudioPlaylistsParams params,
  ) =>
      audioPlaylistsRepository.getAudioPlaylists(
          accessToken: params.accessToken,
          id: params.id,
          pageNo: params.pageNo,);
}

class GetAudioPlaylistsParams extends Equatable {
  final String accessToken;
  final int pageNo;
  final int id;

  const GetAudioPlaylistsParams({
    required this.accessToken,
    required this.pageNo,
    required this.id,
  });

  @override
  List<Object?> get props => [
        accessToken,
        id,
        pageNo,
      ];
}
