import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class RadioRepository {
  Future<Either<Failure, BaseResponse>> getRadioCategories({
    required String accessToken,
        required int id,

  });
  Future<Either<Failure, BaseResponse>> getRadio({
    required String accessToken,
  });
}
