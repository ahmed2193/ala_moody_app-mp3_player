import 'package:alamoody/features/notification/domain/usecases/change_notification_status_usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;

  NotificationRepositoryImpl({
    required this.notificationRemoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> getNotification({
    required String accessToken,
    required int pageNo,
  }) async {
    try {
      final response = await notificationRemoteDataSource.getNotification(
        accessToken: accessToken,
        pageNo: pageNo,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> changeStatus(
      {required ChangeNotificationStatusParams params,}) async {
    final res =
        await notificationRemoteDataSource.changeNotificationStatus(params);

    try {
      return Right(res);
    } on ServerException catch (failure) {
      return Left(
        ServerFailure(message: failure.message),
      );
    }
  }
}
