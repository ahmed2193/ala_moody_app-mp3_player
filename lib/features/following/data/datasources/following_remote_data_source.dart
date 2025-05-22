import 'package:alamoody/core/api/end_points.dart';
import 'package:alamoody/core/models/artists_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

abstract class FollowingRemoteDataSource {
  Future<BaseResponse> getFollowing({
    required String accessToken,
    required int pageNo,
  });
}

class FollowingRemoteDataSourceImpl implements FollowingRemoteDataSource {
  final ApiConsumer apiConsumer;
  FollowingRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getFollowing({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.followed,
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (responseJson[AppStrings.data].isEmpty) {
      baseResponse.message = 'unexpected errors';
    } else {
      final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];
      baseResponse.data =
          iterable.map((model) => ArtistsModel.fromJson(model)).toList();
      baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
      baseResponse.lastPage =
          responseJson[AppStrings.data][AppStrings.lastPage];
    }
    return baseResponse;
  }
}
