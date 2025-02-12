import 'package:alamoody/core/api/end_points.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/models/song_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

abstract class GenresRemoteDataSource {
  Future<BaseResponse> getGenres({
    required String accessToken,
    required int pageNo,
  });
}

class GenresRemoteDataSourceImpl implements GenresRemoteDataSource {
  final ApiConsumer apiConsumer;
  GenresRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getGenres({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.occasions,
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
