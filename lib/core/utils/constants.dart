import 'dart:convert';

import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/dialogs/on_plan_dialog.dart';
import 'package:alamoody/features/membership/presentation/cubit/unsubscribe_plan_cubit/unsubscribe_plan_cubit.dart';
import 'package:alamoody/features/profile/presentation/cubits/profile/profile_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../config/locale/app_localizations.dart';
import '../../config/themes/colors.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/membership/presentation/cubit/coupon_cubit/coupon_cubit.dart';
import '../../features/membership/presentation/cubit/plan_cubit.dart';
import 'app_strings.dart';
import 'dialogs/confirmation_dialog.dart';

// ignore: avoid_classes_with_only_static_members
class Constants {
  static const double desktopBreakpoint = 950;
  static const double tabletBreakpoint = 600;
  static const double watchBreakpoint = 300;
  static const double bottomMarginMainScreen = 60;
  static const int fetchLimit = 50;
  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.translate('ok')!),
          ),
        ],
      ),
    );
  }

  static Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        alertMsg: AppLocalizations.of(context)!.translate('want_to_logout')!,
        onTapConfirm: () => context.read<LoginCubit>().logout(context: context),
      ),
    );
  }

  static Future<void> deleteAccountDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        alertMsg: AppLocalizations.of(context)!
            .translate('do_u_want_delete_account')!,
        onTapConfirm: () => context.read<LoginCubit>().deleteAccount(
              context: context,
              accessToken:
                  context.read<LoginCubit>().authenticatedUser!.accessToken!,
            ),
      ),
    );
  }

  static Future<void> unsubscribePlanDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        alertMsg: AppLocalizations.of(context)!
            .translate('do_u_want_unsubscribe_plan')!,
        onTapConfirm: () {
          context.read<UnsubscribePlanCubit>().unsubscribePlan(
                accessToken:
                    context.read<LoginCubit>().authenticatedUser!.accessToken!,
              );
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  static Future<void> cancelPlanDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        alertMsg:
            AppLocalizations.of(context)!.translate('do_u_want_cancel_plan')!,
        onTapConfirm: () {
          context.read<UnsubscribePlanCubit>().unsubscribePlan(
                accessToken:
                    context.read<LoginCubit>().authenticatedUser!.accessToken!,
              );
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  static Future<void> subscribeToPlans(
    BuildContext context,
    String planName,
    String messageTxt,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        alertMsg: messageTxt,
        // AppLocalizations.of(context)!.translate('do_u_want_cancel_plan')!,
        onTapConfirm: () {
          planName.contains('Free Plan') || planName.contains('No Plan')
              ? BlocProvider.of<PlanCubit>(context).directsubscribeToPlans(
                  accessToken: context
                      .read<LoginCubit>()
                      .authenticatedUser!
                      .accessToken!,
                  planId:
                      BlocProvider.of<PlanCubit>(context).rxPlanNumber.value,
                )
              : BlocProvider.of<PlanCubit>(context).subscribeToPlans(
                  accessToken: context
                      .read<LoginCubit>()
                      .authenticatedUser!
                      .accessToken!,
                  planId:
                      BlocProvider.of<PlanCubit>(context).rxPlanNumber.value,
                  couponCode:
                      context.read<CouponCubit>().couponController.text.isEmpty
                          ? ''
                          : context.read<CouponCubit>().couponController.text,
                );
          context.read<CouponCubit>().couponController.clear();
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  static Future<void> onPlanDialog(BuildContext context) async {
    final planDes =
        " ${AppLocalizations.of(context)!.translate('on_plan')} ' ${context.read<ProfileCubit>().userProfileData!.user!.subscription!.planName} ' ${AppLocalizations.of(context)!.translate('change_plan')}";
    return showDialog(
      context: context,
//       on_plan
// change_plan
      builder: (BuildContext context) => OnPlanDialog(
        alertMsg: planDes,
        onTapConfirm: () => Navigator.of(context).pop(),
        onTapCancel: () {
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  String mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure;
      case CacheFailure:
        return AppStrings.cacheFailure;

      default:
        return AppStrings.unexpectedError;
    }
  }

  static String? handleErrorMsg(BuildContext context, String message) {
    return message == AppStrings.noInternetConnection
        ? AppLocalizations.of(context)!.translate('no_internet_connection')!
        : message == AppStrings.badRequest
            ? AppLocalizations.of(context)!.translate('bad_request')!
            : message == AppStrings.unauthorized
                ? AppLocalizations.of(context)!.translate('unauthorized')!
                : message == AppStrings.requestedInfoNotFound
                    ? AppLocalizations.of(context)!
                        .translate('requested_info_not_found')!
                    : message == AppStrings.conflictOccurred
                        ? AppLocalizations.of(context)!
                            .translate('conflict_occurred')!
                        : message == AppStrings.internalServerError
                            ? AppLocalizations.of(context)!
                                .translate('internal_server_error')!
                            : message == AppStrings.errorDuringCommunication
                                ? AppLocalizations.of(context)!
                                    .translate('errorـduring_communication')!
                                : AppLocalizations.of(context)!
                                    .translate('something_went_wrong')!;
  }

  static void showToast({
    required String message,
    Color? color,
    ToastGravity? gravity,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: color ?? AppColors.cPrimary,
      textColor: Colors.white,
    );
  }

static dynamic decodeJson(Response<dynamic> response) {
    final responseJson = jsonDecode(response.data.toString());
    return responseJson;
  }

  static String formatNumber(int number) {
    if (number >= 1000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(1)}T';
    } else if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}G';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }
}
