import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../models/radio_category_model.dart';
import '../models/radio_model.dart';

abstract class RadioRemoteDataSource {
  Future<BaseResponse> getRadio({
    required String accessToken,
  });
  Future<BaseResponse> getRadioCategories({
    required String accessToken,
    required int id,
  });
}

class RadioRemoteDataSourceImpl implements RadioRemoteDataSource {
  final ApiConsumer apiConsumer;
  RadioRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getRadio({
    required String accessToken,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.radio,
      headers: {AppStrings.authorization: accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    final Iterable iterable = responseJson[AppStrings.data];
    baseResponse.data =
        iterable.map((model) => RadioModel.fromJson(model)).toList();

    return baseResponse;
  }

  @override
  Future<BaseResponse> getRadioCategories({
    required String accessToken,
    required int id,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.radioCategory + id.toString(),
      headers: {AppStrings.authorization: accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    final Iterable iterable = responseJson[AppStrings.data];
    baseResponse.data =
        iterable.map((model) => RadioCategoryModel.fromJson(model)).toList();

    return baseResponse;
  }
}
