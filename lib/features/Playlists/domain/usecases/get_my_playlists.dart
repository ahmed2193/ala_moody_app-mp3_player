import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/playlists_repository.dart';

class GetMyPlaylists implements UseCase<BaseResponse, GetMyPlayListsParams> {
  final PlaylistsRepository playListsRepository;
  GetMyPlaylists({required this.playListsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetMyPlayListsParams params,
  ) =>
      playListsRepository.getMyplayLists(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
      );
}

class GetMyPlayListsParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetMyPlayListsParams({required this.pageNo, required this.accessToken});

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
