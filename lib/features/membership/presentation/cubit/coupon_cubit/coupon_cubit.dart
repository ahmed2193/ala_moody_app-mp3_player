import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/features/membership/data/models/coupon_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/helper/print.dart';
import '../../../../../core/utils/constants.dart';
import '../../../domain/usecases/coupon_code.dart';

part 'coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  final TextEditingController couponController = TextEditingController(text: '');
  final FocusNode couponFocusNode = FocusNode();
  final CouponCodeUseCase couponCodeUseCase;
  // CouponCodeCubit({required this.CouponCodeUseCase})
  //     : super(CouponCodeInitial());
  CouponCubit({required this.couponCodeUseCase}) : super(CouponInitial()) {
    couponFocusNode.addListener(_onFocusChange);
  }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CouponModel? couponModel;
  void applyCoupon({
    required String accessToken,
    required String planId,
  }) async {
    emit(CouponLoading());
    if (couponController.text.isNotEmpty) {
      final Either<Failure, BaseResponse> response = await couponCodeUseCase(
        CouponCodeParams(
          accessToken: accessToken,
          planId: planId,
          coupon: couponController.text,
        ),
      );
      emit(
        response.fold(
          (failure) => CouponError(
              error: Constants().mapFailureToMsg(failure),
              isFocused: couponFocusNode.hasFocus,),
          (data) {
            couponModel = data.data;
            printColored(data.data.data);
            return couponModel!.status == true
                ? CouponApplied(
                    couponCode: couponController.text,
                    isFocused: couponFocusNode.hasFocus,)
                : CouponError(
                    error: couponModel!.msg!,
                    isFocused: couponFocusNode.hasFocus,);
          },
        ),
      );
    }
  }

  void _onFocusChange() {
    emit(CouponFocusState(isFocused: couponFocusNode.hasFocus));
  }

  @override
  Future<void> close() {
    couponController.dispose();
    couponFocusNode.removeListener(_onFocusChange);
    couponFocusNode.dispose();
    return super.close();
  }
}
