


import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/models/song_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

abstract class OccasionsRemoteDataSource {
  Future<BaseResponse> getOccasions({
    required String accessToken,
    required int pageNo,
    required String id,
    required String txt,
  });
}

class OccasionsRemoteDataSourceImpl implements OccasionsRemoteDataSource {
  final ApiConsumer apiConsumer;
  OccasionsRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getOccasions({
    required String accessToken,
    required int pageNo,
    required String id,
    required String txt,
  }) async {
    final response = await apiConsumer.get(
      // 'genres/1/songs',
      '$txt$id/songs',
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    // log(responseJson[AppStrings.data]);
    // log(responseJson[AppStrings.data].toString());
    //  && jsonData["data"] is Map && jsonData["data"].isEmpty
    if (responseJson[AppStrings.data].isEmpty) {
      baseResponse.message = 'unexpected errors';
    } else {
      final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];
      baseResponse.data =
          iterable.map((model) => SongModel.fromJson(model)).toList();
      baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
      baseResponse.lastPage =
          responseJson[AppStrings.data][AppStrings.lastPage];
    }
    return baseResponse;
  }
}
