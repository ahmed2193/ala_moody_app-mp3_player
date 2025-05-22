import 'package:alamoody/core/api/end_points.dart';
import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/features/ads/data/models/ads_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/status_code.dart';
import '../../../../core/models/song_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

abstract class AdsRemoteDataSource {
  Future<BaseResponse> getAds(
  );
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final ApiConsumer apiConsumer;
  AdsRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getAds(
  ) async {
    final response = await apiConsumer.get(
      EndPoints.ads,
 
    );
    printColored(response.statusCode * 100, colorCode: 32);
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);

    if (response.statusCode == StatusCode.ok) {
      printColored('okkk' * 100, colorCode: 33);
      final responseJson = Constants.decodeJson(response);

      baseResponse.data = AdsModel.fromJson(responseJson);
    
      return baseResponse;
    } else {
      printColored('ERRROR' * 100, colorCode: 31);

      baseResponse.message = 'error';
      return baseResponse;
    }
    // final responseJson = Constants.decodeJson(response);
  }
}
