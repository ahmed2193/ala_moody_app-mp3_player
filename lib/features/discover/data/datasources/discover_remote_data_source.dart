import 'package:alamoody/core/api/end_points.dart';
import 'package:alamoody/core/helper/print.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/status_code.dart';
import '../../../../core/models/song_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

abstract class DiscoverRemoteDataSource {
  Future<BaseResponse> getDiscover({
    required String accessToken,
    required int pageNo,
  });
}

class DiscoverRemoteDataSourceImpl implements DiscoverRemoteDataSource {
  final ApiConsumer apiConsumer;
  DiscoverRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getDiscover({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.discover,
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );
    printColored(response.statusCode * 100, colorCode: 32);
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);

    if (response.statusCode == StatusCode.ok) {
      printColored('okkk' * 100, colorCode: 33);
      final responseJson = Constants.decodeJson(response);

      final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];
      baseResponse.data =
          iterable.map((model) => SongModel.fromJson(model)).toList();
      baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
      baseResponse.lastPage =
          responseJson[AppStrings.data][AppStrings.lastPage];
      return baseResponse;
    } else {
      printColored('ERRROR' * 100, colorCode: 31);

      baseResponse.message = 'error';
      return baseResponse;
    }
    // final responseJson = Constants.decodeJson(response);
  }
}
