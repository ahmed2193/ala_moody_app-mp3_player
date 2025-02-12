import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/status_code.dart';
import '../../../../core/helper/print.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../model/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<BaseResponse> updateUserProfile({
    required String accessToken,
    required String email,
    required String name,
    required String userName,
    required String gender,
    required String birthDate,
    required String bio,
    required String countryId,
    required String phoneNumber,
    File? profilePhoto,
  });
Future<BaseResponse> getUserProfile({
    required String accessToken,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;
  ProfileRemoteDataSourceImpl({required this.apiConsumer});
  @override
 Future<BaseResponse> getUserProfile({
    required String accessToken,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.profile,
      headers: {AppStrings.authorization: accessToken},
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);

    if (response.statusCode == StatusCode.ok) {
          final responseJson = Constants.decodeJson(response);
      baseResponse.data = UserProfile.fromJson(responseJson);
    } else {
      baseResponse.message =  'error';
    }
    return baseResponse; 
;
  }

  @override
  Future<BaseResponse> updateUserProfile({
    required String accessToken,
    required String email,
    required String name,
    required String userName,
    required String gender,
    required String birthDate,
    required String bio,
    required String countryId,
    required String phoneNumber,
    File? profilePhoto,
  }) async {
    printColored('name');
    printColored(name);
    printColored('gender');
    printColored(gender);
    printColored('birthDate');
    printColored(birthDate);
    printColored('phoneNumber');
    printColored(phoneNumber);

    final response = await apiConsumer.post(
      EndPoints.updateprofile,
      headers: {
        AppStrings.authorization: accessToken,
      },
      formDataIsEnabled: true,
      body: {
        AppStrings.email: email,
        AppStrings.name: name,
        AppStrings.userName: userName,
        AppStrings.gender: gender,
        AppStrings.birthDate: birthDate,
        AppStrings.bio: bio,
        AppStrings.country: countryId,
        AppStrings.phoneNumber: phoneNumber,
        if (profilePhoto != null) ...{
          AppStrings.profilePhoto:
              await MultipartFile.fromFile(profilePhoto.absolute.path),
        },
      },
    );
    log(profilePhoto.toString(), name: 'profilePhoto');

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      // String accessToken = response.headers[AppStrings.token].toString();
      // accessToken = AppStrings.bearer +
      //     accessToken.replaceAll("[", '').replaceAll("]", '');
      // UserModel userModel = UserModel.fromJson(responseJson);
      // userModel.accessToken = accessToken;
      // baseResponse.data = userModel;
      // => baseResponse.message = responseJson[AppStrings.message];

      baseResponse.message = AppStrings.message;
    } else {
      baseResponse.message = responseJson[AppStrings.message];
    }
    return baseResponse;
  }
}
