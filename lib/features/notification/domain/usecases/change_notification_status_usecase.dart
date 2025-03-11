import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/notification/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ChangeNotificationStatusUseCase
    extends UseCase<BaseResponse, ChangeNotificationStatusParams> {
  final NotificationRepository baseNotificationsRepository;

  ChangeNotificationStatusUseCase({required this.baseNotificationsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
      ChangeNotificationStatusParams params,) async {
    return baseNotificationsRepository.changeStatus(params: params);
  }
}

class ChangeNotificationStatusParams extends Equatable {
  final String notificationId;
  final String accessToken;

  const ChangeNotificationStatusParams({
    required this.notificationId,
    required this.accessToken,
  });

  @override
  List<Object> get props => [
    notificationId,
    accessToken,
    ];
}
