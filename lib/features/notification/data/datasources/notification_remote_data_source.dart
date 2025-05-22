import 'package:alamoody/core/api/status_code.dart';
import 'package:alamoody/features/notification/domain/usecases/change_notification_status_usecase.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<BaseResponse> getNotification({
    required String accessToken,
    required int pageNo,
  });

  Future<BaseResponse> changeNotificationStatus(
      ChangeNotificationStatusParams params,);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiConsumer apiConsumer;
  NotificationRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getNotification({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      
      EndPoints.notifications,
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    // printColored(responseJson[AppStrings.data], colorCode:35 );
    // printColored(responseJson[AppStrings.data][AppStrings.data]);

    final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];
    baseResponse.data =
        iterable.map((model) => NotificationModel.fromJson(model)).toList();
    baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
    baseResponse.lastPage = responseJson[AppStrings.data][AppStrings.lastPage];
    return baseResponse;
  }

  @override
  Future<BaseResponse> changeNotificationStatus(
    ChangeNotificationStatusParams params,
  ) async {
    final response = await apiConsumer.get(
      '${AppStrings.changeStatus}/${params.notificationId}',
         headers: {AppStrings.authorization:params. accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.data = responseJson[AppStrings.data];
    } else {
      baseResponse.message = responseJson['error'] ?? 'error';
    }
    return baseResponse;
  }
}
