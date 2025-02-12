
import 'package:alamoody/features/notification/domain/usecases/change_notification_status_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/usecases/get_notification.dart';

part 'get_notification_state.dart';

class GetNotificationCubit extends Cubit<GetNotificationState> {
  final GetNotification getNotificationUseCase;
  final ChangeNotificationStatusUseCase changeNotificationStatusUseCase;

  GetNotificationCubit(
      {required this.getNotificationUseCase,
      required this.changeNotificationStatusUseCase,})
      : super(GetNotificationInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Notification> notification = [];

  Future<void> getNotification({
    String? accessToken,
  }) async {
    if (state is GetNotificationIsLoading) return;
    emit(GetNotificationIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getNotificationUseCase(
      GetNotificationParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => GetNotificationError(message: failure.message),
          (value) {
        notification.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return GetNotificationLoaded();
      }),
    );
  }

  Future<void> changeStatus({required int nId}) async {
    final response = await changeNotificationStatusUseCase(
        ChangeNotificationStatusParams(notificationId: nId.toString()),);
    response.fold(
      (failure) => GetNotificationError(message: failure.message),
      (projectData) {
        // isLiked.sink.add(!projectData.data.isLiked);
        print(projectData);
      },
    );
  }

  clearData() {
    if (notification.isNotEmpty) {
      notification.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
