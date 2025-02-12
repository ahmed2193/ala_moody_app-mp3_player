import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/occasions_repository.dart';

class GetOccasions implements UseCase<BaseResponse, GetOccasionsParams> {
  final OccasionsRepository occasionsRepository;
  GetOccasions({required this.occasionsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetOccasionsParams params,
  ) =>
      occasionsRepository.getOccasions(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
        id: params.id,
        txt: params.txt,
      );
}

class GetOccasionsParams extends Equatable {
  final String accessToken;
  final String id;
  final int pageNo;
  final String txt;

  const GetOccasionsParams(
      {required this.pageNo, required this.accessToken, required this.id,required this.txt,});

  @override
  List<Object?> get props => [accessToken, pageNo, id, txt];
}
