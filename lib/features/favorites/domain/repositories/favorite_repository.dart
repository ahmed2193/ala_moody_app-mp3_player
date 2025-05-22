import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, BaseResponse>> getFavorite({
    required String accessToken,
    required int pageNo,
  });
    Future<Either<Failure, BaseResponse>> addAndRemoveFromFavorites({
    required String accessToken,
    required String type,
    required String id,
  });
}
