import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class OccasionsRepository {
  Future<Either<Failure, BaseResponse>> getOccasions({
    required String accessToken,
    required String id,
    required String txt,
    required int pageNo,
  });
}
