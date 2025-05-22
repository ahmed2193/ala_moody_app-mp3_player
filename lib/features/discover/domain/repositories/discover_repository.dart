import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class DiscoverRepository {
  Future<Either<Failure, BaseResponse>> getDiscover({
    required String accessToken,
    required int pageNo,
  });
}
