import 'package:alamoody/features/discover/domain/repositories/discover_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';

class GetDiscover implements UseCase<BaseResponse, GetDiscoverParams> {
  final DiscoverRepository discoverRepository;
  GetDiscover({required this.discoverRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetDiscoverParams params,
  ) =>
      discoverRepository.getDiscover(
          accessToken: params.accessToken,
          pageNo: params.pageNo,
       );
}

class GetDiscoverParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetDiscoverParams(
      {required this.pageNo, required this.accessToken, });

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
