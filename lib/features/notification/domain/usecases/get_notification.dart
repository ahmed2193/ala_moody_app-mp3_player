import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

class GetNotification implements UseCase<BaseResponse, GetNotificationParams> {
  final NotificationRepository notificationRepository;
  GetNotification({required this.notificationRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetNotificationParams params,
  ) =>
      notificationRepository.getNotification(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
      );
}

class GetNotificationParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetNotificationParams({
    required this.pageNo,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
