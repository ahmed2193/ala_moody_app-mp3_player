import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class FollowingRepository {
  Future<Either<Failure, BaseResponse>> getFollowing({
    required String accessToken,
    required int pageNo,
  });
}
