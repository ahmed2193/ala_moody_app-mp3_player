import 'package:dartz/dartz.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class SearchRepository {
  Future<Either<Failure, BaseResponse>> getCategory({
    required String accessToken,
    required int pageNo,
    required String searchTxt,
  });
  Future<Either<Failure, BaseResponse>> search({
    required String accessToken,
    required String searchTxt,
  });
}
