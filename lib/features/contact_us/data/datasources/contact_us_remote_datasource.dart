import 'package:alamoody/core/api/api_consumer.dart';
import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/api/end_points.dart';
import 'package:alamoody/core/api/status_code.dart';
import 'package:alamoody/core/utils/app_strings.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/features/contact_us/domain/usecases/send_form_usecase.dart';

abstract class BaseContactUsRemoteDataSource {
  Future<BaseResponse> sendData(ContactUsParams params);
}

class ContactUsRemoteDataSource extends BaseContactUsRemoteDataSource {
  ContactUsRemoteDataSource({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<BaseResponse> sendData(ContactUsParams params) async {
    final response = await apiConsumer.post(
      EndPoints.contactUs,
      headers: {
        AppStrings.authorization: params.token,
      },
      body: {
        AppStrings.title: params.title,
        AppStrings.message: params.message,
        AppStrings.subject: params.subject,
      },
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.message = responseJson['message'];
    } else {
      baseResponse.message = responseJson['message'] ?? 'error';
    }
    return baseResponse;
  }
}
