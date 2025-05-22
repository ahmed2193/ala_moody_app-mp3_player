import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/features/contact_us/domain/usecases/send_form_usecase.dart';

import 'package:dartz/dartz.dart';

abstract class BaseContactUsRepository {
  Future<Either<Failure, BaseResponse>> getLikedProjects(
      {required ContactUsParams params,});
}
