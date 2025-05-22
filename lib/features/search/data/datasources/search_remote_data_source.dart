
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../models/category_model.dart';
import '../models/search_model.dart';

abstract class SearchRemoteDataSource {
  Future<BaseResponse> getCategory({
    required int pageNo,
    required String accessToken,
    required String searchTxt,
  });
  Future<BaseResponse> search({
    required String accessToken,
    required String searchText,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiConsumer apiConsumer;
  SearchRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getCategory({
    required String accessToken,
    required String searchTxt,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.categories,
      // 'search/song',
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
                // AppStrings.search: 'te',
        AppStrings.search: searchTxt,

      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];
    baseResponse.data =
        iterable.map((model) => CategoryModel.fromJson(model)).toList();
    baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
    baseResponse.lastPage = responseJson[AppStrings.data][AppStrings.lastPage];
    return baseResponse;
  }

  @override
  Future<BaseResponse> search(
      {required String accessToken, required String searchText,}) async {
    final response = await apiConsumer.get(
      EndPoints.search,
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.search: searchText,
      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    baseResponse.data = SearchModel.fromJson(responseJson[AppStrings.data]);

    return baseResponse;
  }
}
