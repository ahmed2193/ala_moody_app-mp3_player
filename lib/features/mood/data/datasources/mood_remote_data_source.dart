import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/models/song_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../models/moods_model.dart';

abstract class MoodRemoteDataSource {
  Future<BaseResponse> getMood({
    required String accessToken,
  });

  Future<BaseResponse> getMoodsongs({
    required String accessToken,
    required int id,
    required int pageNo,
  });
}

class MoodRemoteDataSourceImpl implements MoodRemoteDataSource {
  final ApiConsumer apiConsumer;
  MoodRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getMood({
    required String accessToken,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.moods,
      headers: {AppStrings.authorization: accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];
    baseResponse.data =
        iterable.map((model) => MoodsModel.fromJson(model)).toList();

    return baseResponse;
  }

  @override
  Future<BaseResponse> getMoodsongs(
      {required String accessToken,
      required int id,
      required int pageNo,}) async {
    final response = await apiConsumer.get(
      '${EndPoints.moods}/$id/${AppStrings.songs}',
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];

    baseResponse.data =
        iterable.map((model) => SongModel.fromJson(model)).toList();
    baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
    baseResponse.lastPage = responseJson[AppStrings.data][AppStrings.lastPage];
    return baseResponse;
  }
}
