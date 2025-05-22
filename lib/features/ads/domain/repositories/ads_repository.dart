import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class AdsRepository {
  Future<Either<Failure, BaseResponse>> getAds();
}
