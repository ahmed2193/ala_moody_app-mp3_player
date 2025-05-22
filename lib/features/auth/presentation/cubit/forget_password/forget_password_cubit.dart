import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/forget_password%20.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPassword forgetPasswordUseCase;

  ForgetPasswordCubit({
    required this.forgetPasswordUseCase,
  }) : super(ForgetPasswordInitial());

  bool isloading = false;

  Future<void> forgetPassword({
    required GlobalKey<FormState> formKey,
    required String email,
  }) async {
    if (formKey.currentState!.validate()) {
      changeForgetPasswordView();
      final Either<Failure, BaseResponse> response =
          await forgetPasswordUseCase.call(ForgetPasswordParams(
        email: email,
      ),);
      changeForgetPasswordView();
      response.fold(
          (failure) => emit(ForgetPasswordFailed(message: failure.message!)),
          (response) async {
        if (response.statusCode == StatusCode.ok) {
          emit(ForgetPasswordSuccess(message: response.message!));
        } else {
          emit(ForgetPasswordFailed(message: response.message!));
        }
      });
    } else {
      emit(ForgetPasswordValidatation(isValidate: true));
    }
  }

  void changeForgetPasswordView() {
    isloading = !isloading;
    emit(ForgetPasswordLoading(isloading));
  }
}
