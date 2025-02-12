import 'package:alamoody/features/live_stream/data/model/live_users_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/status_code.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

abstract class LiveRemoteDataSource {
  Future<BaseResponse> getLiveUser({
    required String accessToken,
  });
  Future<BaseResponse> creatUserIsLive({
    required String accessToken,
    required String isLive,
  });
}

class LiveRemoteDataSourceImpl implements LiveRemoteDataSource {
  final ApiConsumer apiConsumer;
  LiveRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getLiveUser({
    required String accessToken,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.liveUsers,
      headers: {AppStrings.authorization: accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    final Iterable iterable = responseJson[AppStrings.users];
    baseResponse.data =LiveUserModel.fromJson(responseJson);
        // iterable.map((model) => ).toList();

    return baseResponse;
  }

  @override
  Future<BaseResponse> creatUserIsLive({
    required String accessToken,
    required String isLive,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.usersIsLive,
      body: {
       AppStrings. isLive:isLive,
      },
      headers: {AppStrings.authorization: accessToken},
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.message = AppStrings.success;
    } else {
      baseResponse.message = responseJson[AppStrings.message];
    }
    return baseResponse;
  }
}
