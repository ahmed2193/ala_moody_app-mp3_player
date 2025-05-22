import 'package:alamoody/features/auth/domain/usecases/update_token.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/status_code.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../models/register_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<BaseResponse> login({
    required String email,
    required String password,
    required String fcmToken,
  });

  Future<BaseResponse> register({
    required String name,
    required String userName,
    required String email,
    required String password,
  });
  Future<BaseResponse> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String accessToken,
  });
  Future<BaseResponse> deleteAccount({
    required String accessToken,
  });
  Future<BaseResponse> forgetPassword({required String email});
  Future<BaseResponse> loginwiWthMobileNumber({
    required String phone,
    required String mobileFlag,
    required String userName,
    required String fcmToken,
  });

  Future<BaseResponse> registerWithMobileNumber({
    required String phone,
    required String mobileFlag,
    required String userName,
  });

  Future<BaseResponse> loginWithSocialMedia({
    required String email,
    required int isGoogle,
    required String displayName,
    required String socialId,
    required String fcmToken,
  });
  Future<BaseResponse> updateDeviceToken({
    required UpdateTokenParams params,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;
  AuthRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.login,
      body: {
        AppStrings.userName: email,
        AppStrings.password: password,
        AppStrings.fcmToken: fcmToken,
      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      final UserModel userModel = UserModel.fromJson(responseJson);
      baseResponse.data = userModel;
    } else {
      if (responseJson[AppStrings.errors][AppStrings.message] != null) {
        baseResponse.message =
            responseJson[AppStrings.errors][AppStrings.message][0];
      } else {
        baseResponse.message =
            responseJson[AppStrings.errors][AppStrings.userName][0];
      }
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> register({
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.register,
      body: {
        AppStrings.name: name,
        AppStrings.userName: userName,
        AppStrings.email: email,
        AppStrings.password: password,
      },
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      final RegisterModel userModel = RegisterModel.fromJson(responseJson);
      baseResponse.data = userModel;
    } else {
      if (responseJson[AppStrings.errors][AppStrings.email] != null &&
          responseJson[AppStrings.errors][AppStrings.userName] != null) {
        baseResponse.message =
            '${responseJson[AppStrings.errors][AppStrings.email][0]} \n ${responseJson[AppStrings.errors][AppStrings.userName][0] ?? ''} ';
      } else if (responseJson[AppStrings.errors][AppStrings.email] != null) {
        baseResponse.message =
            '${responseJson[AppStrings.errors][AppStrings.email][0]}  ';
      } else {
        baseResponse.message =
            '${responseJson[AppStrings.errors][AppStrings.userName][0]}  ';
      }
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String accessToken,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.resetPassword,
      body: {
        AppStrings.oldPassword: oldPassword,
        AppStrings.password: newPassword,
        AppStrings.passwordConfirmation: newPassword,
      },
      headers: {AppStrings.authorization: accessToken},
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.message = responseJson[AppStrings.message];
    } else {
      baseResponse.message =
          responseJson[AppStrings.errors][AppStrings.message][0];
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> forgetPassword({required String email}) async {
    final response = await apiConsumer.post(
      EndPoints.forgetPassword,
      body: {
        AppStrings.email: email,
      },
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.message = responseJson[AppStrings.message];
    } else {
      baseResponse.message =
          responseJson[AppStrings.errors][AppStrings.email][0];
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> loginwiWthMobileNumber({
    required String phone,
    required String mobileFlag,
    required String userName,
    required String fcmToken,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.login,
      body: {
        AppStrings.phone: phone,
        AppStrings.mobileFlag: mobileFlag,
        AppStrings.userName: userName,
        AppStrings.fcmToken: fcmToken,
      },
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      final UserModel userModel = UserModel.fromJson(responseJson);
      baseResponse.data = userModel;
    } else {
      baseResponse.message = responseJson[AppStrings.message];
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> registerWithMobileNumber({
    required String phone,
    required String mobileFlag,
    required String userName,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.register,
      body: {
        AppStrings.phone: phone,
        AppStrings.mobileFlag: mobileFlag,
        AppStrings.userName: userName,
      },
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok &&
        !responseJson[AppStrings.message].contains('Unauthorized')) {
      final RegisterModel userModel = RegisterModel.fromJson(responseJson);
      baseResponse.data = userModel;
    } else {
      if (responseJson[AppStrings.errors][AppStrings.phone] != null &&
          responseJson[AppStrings.errors][AppStrings.userName] != null) {
        baseResponse.message =
            '${responseJson[AppStrings.errors][AppStrings.phone][0]} \n ${responseJson[AppStrings.errors][AppStrings.userName][0] ?? ''} ';
      } else if (responseJson[AppStrings.errors][AppStrings.phone] != null) {
        baseResponse.message =
            '${responseJson[AppStrings.errors][AppStrings.phone][0]}  ';
      } else {
        baseResponse.message =
            '${responseJson[AppStrings.errors][AppStrings.phone][0]}  ';
      }
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> loginWithSocialMedia({
    required String email,
    required int isGoogle,
    required String displayName,
    required String socialId,
    required String fcmToken,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.loginWithSoialMedia,
      body: {
        AppStrings.email: email,
        AppStrings.displayName: displayName,
        AppStrings.isGoogle: isGoogle,
        AppStrings.socialId: socialId,
        AppStrings.fcmToken: fcmToken,
      },
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      final UserModel userModel = UserModel.fromJson(responseJson);
      baseResponse.data = userModel;
    } else {
      if (responseJson[AppStrings.errors][AppStrings.message] != null) {
        baseResponse.message =
            responseJson[AppStrings.errors][AppStrings.message][0];
      } else {
        baseResponse.message =
            responseJson[AppStrings.errors][AppStrings.userName][0];
      }
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> updateDeviceToken({
    required UpdateTokenParams params,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.updateToken,
      headers: {AppStrings.authorization: params.accessToken},
      body: {
        AppStrings.token: params.token,
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

  @override
  Future<BaseResponse> deleteAccount({required String accessToken}) async {
    final response = await apiConsumer.get(
      EndPoints.deleteAccount,
      headers: {AppStrings.authorization: accessToken},
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      // log(responseJson[AppStrings.message]);
      baseResponse.message = 'Deleted Successfully';
    } else {
      baseResponse.message = 'error';
    }
    return baseResponse;
  }
}
