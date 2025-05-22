// Save Song on track play
// SaveSongOnTrackPlay

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class SaveSongOnTrackPlay
    implements UseCase<BaseResponse, SaveSongOnTrackPlayParams> {
  final HomeRepository homeRepository;
  SaveSongOnTrackPlay({required this.homeRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    SaveSongOnTrackPlayParams params,
  ) async =>
      homeRepository.saveSongOnTrackPlay(
        type: params.type,
        id: params.id,
        accessToken: params.accessToken,
      );
}

class SaveSongOnTrackPlayParams extends Equatable {
  final String type;
  final String id;
  final String accessToken;

  const SaveSongOnTrackPlayParams({
    required this.type,
    required this.id,
    required this.accessToken,
  });

  @override
  List<Object> get props => [type, id, accessToken];
}
