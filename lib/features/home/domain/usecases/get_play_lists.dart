import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class GetPlaylists implements UseCase<BaseResponse, GetPlayListsParams> {
  final HomeRepository playListsRepository;
  GetPlaylists({required this.playListsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetPlayListsParams params,
  ) =>
      playListsRepository.getplayLists(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
      );
}

class GetPlayListsParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetPlayListsParams({required this.pageNo, required this.accessToken});

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
