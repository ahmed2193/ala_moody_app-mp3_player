import 'dart:developer';

import 'package:alamoody/features/auth/domain/usecases/register_with_mobile_number.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../data/models/register_model.dart';
import '../../../domain/usecases/register.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final Register registerUseCase;
  final RegisterWithMobileNumber registerWithMobileNumberUseCase;

  RegisterCubit({
    required this.registerUseCase,
    required this.registerWithMobileNumberUseCase,
  }) : super(RegisterInitial());

  bool isloading = false;
  RegisterModel? authenticatedUser;
  String? verificationIds;
  String? phoneNumber;
  String? userName;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> register({
    required GlobalKey<FormState> formKey,
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async {
    if (formKey.currentState!.validate()) {
      changeRegisterView();
      final Either<Failure, BaseResponse> response = await registerUseCase.call(
        RegisterParams(
          name: name,
          userName: userName,
          email: email,
          password: password,
        ),
      );
      changeRegisterView();
      response
          .fold((failure) => emit(RegisterFailed(message: failure.message!)),
              (response) async {
        if (response.statusCode == StatusCode.ok) {
          authenticatedUser = response.data;

          emit(RegisterSuccess(authenticatedUser: response.data));
        } else {
          emit(RegisterFailed(message: response.message!));
        }
      });
    } else {
      emit(RegisterValidatation(isValidate: true));
    }
  }

  Future<void> registerWithMobileNumber({
    required String otp,
  }) async {
    changeRegisterView();

    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationIds!,
      smsCode: otp,
    );

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential).catchError((error) {
      changeRegisterView();

      emit(RegisterFailed(message: error.toString()));
    });

    if (auth.currentUser != null) {
      log('login with phon successfully');
      final Either<Failure, BaseResponse> response =
          await registerWithMobileNumberUseCase.call(
        RegisterWithMobileNumberParams(
          phone: phoneNumber!,
          userName: userName!,
          mobileFlag: '1',
        ),
      );
      changeRegisterView();
      response
          .fold((failure) => emit(RegisterFailed(message: failure.message!)),
              (response) async {
        if (response.statusCode == StatusCode.ok) {
          authenticatedUser = response.data;

          emit(RegisterSuccess(authenticatedUser: response.data));
        } else {
          emit(RegisterFailed(message: response.message!));
        }
      });
    } else {
      changeRegisterView();

      emit(RegisterFailed(message: 'Register with phone error '));
    }

    // }
    //  else {
    //   emit(RegisterValidatation(isValidate: true));
    // }
  }

  Future<void> verifyPhoneNumber({
    required String phone,
  }) async {
    changeRegisterView();
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        log('verificationCompleted');
      },
      // timeout: const Duration(seconds: 30),
      verificationFailed: (FirebaseAuthException e) {
        log('verificationFailed');
        changeRegisterView();

        log(e.message.toString());
        emit(RegisterFailed(message: e.message!));
      },
      codeSent: (String verificationId, int? resendToken) {
        log('codeSent');

        changeRegisterView();
        phoneNumber = phone;
        verificationIds = verificationId;
        emit(VerifyPhoneNumberSuccess());
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('codeAutoRetrievalTimeout');
      },
    );
  }

  void changeRegisterView() {
    isloading = !isloading;
    emit(RegisterLoading(isloading));
  }
}
