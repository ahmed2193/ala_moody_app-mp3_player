import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/reset_password.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPassword resetPasswordUseCase;

  ResetPasswordCubit({
    required this.resetPasswordUseCase,
  }) : super(ResetPasswordInitial());

  bool isloading = false;

  Future<void> resetPassword({
    required GlobalKey<FormState> formKey,
    required String oldPassword,
    required String newPassword,
    required String accessToken,
  }) async {
    if (formKey.currentState!.validate()) {
      changeResetPasswordView();
      final Either<Failure, BaseResponse> response = await resetPasswordUseCase.call(
          ResetPasswordParams(
              accessToken: accessToken,
              newPassword: newPassword,
              oldPassword: oldPassword,),);
      changeResetPasswordView();
      response.fold(
          (failure) => emit(ResetPasswordFailed(message: failure.message!)),
          (response) async {
        if (response.statusCode == StatusCode.ok) {
          emit(ResetPasswordSuccess(message: response.message!));
        } else {
          emit(ResetPasswordFailed(message: response.message!));
        }
      });
    } else {
      emit(ResetPasswordValidatation(isValidate: true));
    }
  }

  void changeResetPasswordView() {
    isloading = !isloading;
    emit(ResetPasswordLoading(isloading));
  }
}
