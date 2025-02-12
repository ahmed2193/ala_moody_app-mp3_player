import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class GetRecentListen implements UseCase<BaseResponse, GetRecentListenParams> {
  final HomeRepository recentListenRepository;
  GetRecentListen({required this.recentListenRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetRecentListenParams params,
  ) =>
      recentListenRepository.getRecentListen(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
      );
}


class GetRecentListenParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetRecentListenParams(
      {required this.pageNo, required this.accessToken,});

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
