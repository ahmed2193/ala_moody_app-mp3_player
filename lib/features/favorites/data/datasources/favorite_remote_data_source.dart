import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/status_code.dart';
import '../../../../core/models/song_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

abstract class FavoriteRemoteDataSource {
  Future<BaseResponse> getFavorite({
    required String accessToken,
    required int pageNo,
  });

  Future<BaseResponse> addAndRemoveFromFavorites({
    required String type,
    required String id,
    required String accessToken,
  });
  
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final ApiConsumer apiConsumer;
  FavoriteRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getFavorite({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.favorites,
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

  @override
  Future<BaseResponse> addAndRemoveFromFavorites(
      {required String type,
      required String id,
      required String accessToken,}) async {
    final response = await apiConsumer.post(
      EndPoints.addAndRemoveFromFav,
      body: {
        AppStrings.songId: id,
        AppStrings.action: type,
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
