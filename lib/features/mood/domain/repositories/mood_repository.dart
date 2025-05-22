import 'package:dartz/dartz.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class MoodRepository {
  Future<Either<Failure, BaseResponse>> getMood({
    required String accessToken,
  });
  Future<Either<Failure, BaseResponse>> getMoodsongs({
    required String accessToken,
    required int id,
    required int pageNo,
  });
}
