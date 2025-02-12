import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class GetPopularSongs implements UseCase<BaseResponse, GetPopularSongsParams> {
  final HomeRepository popularSongsRepository;
  GetPopularSongs({required this.popularSongsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetPopularSongsParams params,
  ) =>
      popularSongsRepository.getPopularSongs(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
      );
}

class GetPopularSongsParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetPopularSongsParams(
      {required this.pageNo, required this.accessToken,});

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
