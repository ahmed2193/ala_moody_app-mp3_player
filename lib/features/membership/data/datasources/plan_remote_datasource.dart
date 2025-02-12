import 'package:alamoody/core/api/api_consumer.dart';
import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/api/end_points.dart';
import 'package:alamoody/core/api/status_code.dart';
import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/utils/app_strings.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/features/membership/data/models/coupon_model.dart';
import 'package:alamoody/features/membership/data/models/plans_list_model.dart';
import 'package:alamoody/features/membership/domain/usecases/get_paln_usecase.dart';
import 'package:alamoody/features/membership/domain/usecases/subscribe_to_plan_usecase.dart';

import '../../domain/usecases/coupon_code.dart';
import '../../domain/usecases/direct_subscribe_to_plan_usecase.dart';

abstract class BasePlanRemoteDataSource {
  Future<BaseResponse> getPlansData(GetPlanParams params);
  Future<BaseResponse> subscribeToPlan(SubscribeToPlanParams params);
  Future<BaseResponse> directsubscribeToPlan(
    DirectSubscribeToPlanParams params,
  );
  Future<BaseResponse> unsubscribePlan(String accessToken);
  Future<BaseResponse> couponCode(CouponCodeParams params);
}

class PlanRemoteDataSource extends BasePlanRemoteDataSource {
  PlanRemoteDataSource({required this.apiConsumer});
  final ApiConsumer apiConsumer;

  @override
  Future<BaseResponse> getPlansData(GetPlanParams params) async {
    final response = await apiConsumer.get(
      EndPoints.subscription,
      headers: {AppStrings.authorization: params.accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.data = PlanListModel.fromJson(responseJson[AppStrings.data]);
    } else {
      baseResponse.message = 'error';
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> subscribeToPlan(SubscribeToPlanParams params) async {
    final response = await apiConsumer.get(
      '${EndPoints.subscribeToPlan}/${params.planId}/${params.couponCode}',
      headers: {AppStrings.authorization: params.accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = response;
    if (response.statusCode == StatusCode.ok) {
      baseResponse.data = responseJson;
    } else {
      baseResponse.message = responseJson['msg'] ?? 'error';
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> directsubscribeToPlan(
    DirectSubscribeToPlanParams params,
  ) async {
    final response = await apiConsumer.post(
      EndPoints.directSubscribeToPlan,
      body: {
        'id': params.planId,
      },
      headers: {AppStrings.authorization: params.accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = response;
    if (response.statusCode == StatusCode.ok) {
      // baseResponse.message = responseJson['message'] ?? 'error';
    } else {
      baseResponse.message = responseJson['message'] ?? 'error';
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> unsubscribePlan(String accessToken) async {
    final response = await apiConsumer.post(
      EndPoints.unsubscription,
      body: {},
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

  @override
  Future<BaseResponse> couponCode(CouponCodeParams params) async {
    printColored('coupon');
    printColored(
      params.coupon,
    );
    printColored('planId');
    printColored(params.planId);
    final response = await apiConsumer.post(
      EndPoints.activeCoupon,
      body: {
        AppStrings.coupon: params.coupon,
        AppStrings.serviceId: params.planId,
      },
      headers: {AppStrings.authorization: params.accessToken},
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    // printColored(responseJson['status']);
    // printColored(responseJson[AppStrings.data]);

    if (response.statusCode == StatusCode.ok) {
      baseResponse.data = CouponModel.fromJson(responseJson);
    } else {
      baseResponse.message = responseJson['msg'] ?? 'error';
    }
    return baseResponse;
  }
}
