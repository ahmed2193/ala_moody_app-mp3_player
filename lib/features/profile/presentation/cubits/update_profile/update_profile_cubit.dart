import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/update_user_profile.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateUserProfile updateUserProfileUseCase;
  UpdateProfileCubit({required this.updateUserProfileUseCase})
      : super(UpdateProfileInitial());

  bool isloading = false;

  Future<void> updateProfile({
    required GlobalKey<FormState> formKey,
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
    if (formKey.currentState!.validate()) {
      changeLoadingView();
      final Either<Failure, BaseResponse> response =
          await updateUserProfileUseCase.call(
        UpdateUserProfileParams(
          accessToken: accessToken,
          email: email,
          name: name,
          userName: userName,
          gender: gender,
          birthDate: birthDate,
          bio: bio,
          countryId: countryId,
          profilePhoto: profilePhoto,
          phoneNumber: phoneNumber,
        ),
      );
      changeLoadingView();
      response.fold(
          (failure) => emit(UpdateProfileFailed(message: failure.message!)),
          (response) async {
        if (response.statusCode == StatusCode.ok) {
          // UserModel user = response.data;
          emit(
            const UpdateProfileSuccess(
                // user: user
                ),
          );
        } else {
          emit(UpdateProfileFailed(message: response.message!));
        }
      });
    } else {
      emit(const UpdateProfileValidatation(isValidate: true));
    }
  }

  void changeLoadingView() {
    isloading = !isloading;
    emit(UpdateProfileLoading(isloading));
  }
}
