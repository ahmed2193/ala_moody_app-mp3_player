import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class GetArtistDetails implements UseCase<BaseResponse, GetArtistDetailsParams> {
  final HomeRepository artistDetailsRepository;
  GetArtistDetails({required this.artistDetailsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetArtistDetailsParams params,
  ) =>
      artistDetailsRepository.getArtistDetails(
        accessToken: params.accessToken,
        id: params.id,
         pageNo: params.pageNo,

      );
}

class GetArtistDetailsParams extends Equatable {
  final String accessToken;
  final int id;
  final int pageNo;

  const GetArtistDetailsParams(
      {required this.id, required this.pageNo,required this.accessToken,});

  @override
  List<Object?> get props => [
        accessToken,
        id,
        pageNo,
      ];
}
