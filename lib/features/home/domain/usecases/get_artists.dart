import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class GetArtists implements UseCase<BaseResponse, GetArtistsParams> {
  final HomeRepository artistsRepository;
  GetArtists({required this.artistsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetArtistsParams params,
  ) =>
      artistsRepository.getArtists(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
      );
}

class GetArtistsParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetArtistsParams(
      {required this.pageNo, required this.accessToken,});

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
