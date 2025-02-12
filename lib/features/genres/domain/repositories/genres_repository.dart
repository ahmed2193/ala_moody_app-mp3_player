import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class GenresRepository {
  Future<Either<Failure, BaseResponse>> getGenres({
    required String accessToken,
    required int pageNo,
  });
}
