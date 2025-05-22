import 'package:alamoody/features/notification/domain/usecases/change_notification_status_usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, BaseResponse>> getNotification({
    required String accessToken,
    required int pageNo,
  });
  Future<Either<Failure, BaseResponse>> changeStatus({
    required ChangeNotificationStatusParams params,
  });
}
