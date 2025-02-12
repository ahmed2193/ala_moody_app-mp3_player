import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class LiveRepository {
  Future<Either<Failure, BaseResponse>> getLiveUser({
    required String accessToken,

  });
  Future<Either<Failure, BaseResponse>> creatUserIsLive({
    required String accessToken,
  required String isLive,
  });
}
