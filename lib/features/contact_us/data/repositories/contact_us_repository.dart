import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/exceptions.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/features/contact_us/data/datasources/contact_us_remote_datasource.dart';
import 'package:alamoody/features/contact_us/domain/repositories/base_contact_us_repository.dart';
import 'package:alamoody/features/contact_us/domain/usecases/send_form_usecase.dart';
import 'package:dartz/dartz.dart';

class LikedProjectsRepository extends BaseContactUsRepository {
  BaseContactUsRemoteDataSource baseProjectsRemoteDataSource;

  LikedProjectsRepository(this.baseProjectsRemoteDataSource);

  @override
  Future<Either<Failure, BaseResponse>> getLikedProjects({
    required ContactUsParams params,
  }) async {
    final res = await baseProjectsRemoteDataSource.sendData(params);
    try {
      return Right(res);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(message: failure.message),
      );
    }
  }
}
