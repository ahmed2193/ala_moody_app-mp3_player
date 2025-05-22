import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class LibraryRepository {
  Future<Either<Failure, BaseResponse>> getLibrary({
    required String accessToken,
    required String type,
    required int pageNo,
  });
}
