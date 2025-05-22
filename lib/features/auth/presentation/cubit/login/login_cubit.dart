// ignore_for_file: avoid_positional_boolean_parameters

import 'package:alamoody/core/helper/user_hive.dart';
import 'package:alamoody/features/auth/domain/usecases/delete_account.dart';
import 'package:alamoody/features/auth/domain/usecases/login_with_mobile_number.dart';
import 'package:alamoody/features/auth/domain/usecases/login_with_soial_media.dart';
import 'package:alamoody/features/auth/domain/usecases/update_token.dart';
import 'package:alamoody/features/main/presentation/screens/auth_screens/data/models/remember_me_model.dart';
import 'package:alamoody/notification_service.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../config/locale/app_localizations.dart';
// import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../../core/utils/usecases/usecase.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/usecases/get_saved_login_credentials.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/logout.dart';
import '../../../domain/usecases/save_login_credentials.dart';
import '../../screen/login_screen.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Login loginUseCase;
  final GetSavedLoginCredentials getSavedLoginCredentialsUseCase;
  final SaveLoginCredentials saveLoginCredentials;
  final Logout logoutUseCase;
  final DeleteAccount deleteAccountUseCase;
  final LoginWithSoialMedia loginWithSoialMediaUseCase;
  final LoginWithMobileNumber loginWithMobileNumberUseCase;
  final UpdateTokenUseCase updateTokenUseCase;
  Map<String, dynamic>? _userData;
  final NotificationService _notificationService = NotificationService();

  LoginCubit({
    required this.loginUseCase,
    required this.getSavedLoginCredentialsUseCase,
    required this.saveLoginCredentials,
    required this.loginWithSoialMediaUseCase,
    required this.logoutUseCase,
    required this.loginWithMobileNumberUseCase,
    required this.updateTokenUseCase,
    required this.deleteAccountUseCase,
  }) : super(LoginInitial());
  bool isloading = false;
  UserModel? authenticatedUser;

  void getSavedLoginCredentials() async {
    debugPrint('getSavedLoginCredentials');
    final response = await getSavedLoginCredentialsUseCase.call(NoParams());
    response.fold((failure) => debugPrint(AppStrings.cacheFailure), (user) {
      if (user != null) {
        authenticatedUser = user;
        emit(Authenticated(authenticatedUser: authenticatedUser));
      }
    });
  }

  Future<void> login({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
    required bool isRememberMe,
  }) async {
    if (formKey.currentState!.validate()) {
      final fcmToken = (await _notificationService.getFcmToken())!;

      changeLoadingView();
      final Either<Failure, BaseResponse> response = await loginUseCase.call(
        LoginParams(
          email: email,
          password: password,
          fcmToken: fcmToken,
        ),
      );
      changeLoadingView();
      response
          .fold((failure) => emit(UnAuthenticated(message: failure.message!)),
              (response) async {
        if (response.statusCode == StatusCode.ok) {
          authenticatedUser = response.data;

          await rememberMe(isRememberMe, email, password);

          await saveLoginCredentials
              .call(SaveLoginCredentialsParams(user: authenticatedUser!));

          await updateToken(authenticatedUser!.accessToken!);
          emit(Authenticated(authenticatedUser: authenticatedUser));
        } else {
          emit(UnAuthenticated(message: response.message!));
        }
      });
    } else {
      emit(LoginValidatation(isValidate: true));
    }
  }

  // remember me
  Future<void> rememberMe(
    bool isRememberMe,
    String email,
    String password,
  ) async {
    if (isRememberMe) {
      await UserHive.rememberUserSignup(
        RememberMeModel(
          email: email,
          password: password,
        ),
      );
      debugPrint('remember me');
    } else {
      await UserHive.clearRememberUserData();
      debugPrint('clear remember me');
    }
  }

  Future<void> updateToken(
    String accessToken,
  ) async {
    FirebaseMessaging.instance.getToken().then((token) async {
      await updateTokenUseCase
          .call(UpdateTokenParams(token: token!, accessToken: accessToken));
    });
  }

  Future<void> loginWithMobileNumber({
    required GlobalKey<FormState> formKey,
    required String phone,
    required String mobileFlag,
    required String userName,
    required bool credentialsIsSaved,
  }) async {
    if (formKey.currentState!.validate()) {
      changeLoadingView();
      final fcmToken = (await _notificationService.getFcmToken())!;
      final Either<Failure, BaseResponse> response =
          await loginWithMobileNumberUseCase.call(
        LoginWithMobileNumberParams(
            phone: phone,
            mobileFlag: mobileFlag,
            userName: userName,
            fcmToken: fcmToken,),
      );
      changeLoadingView();
      response
          .fold((failure) => emit(UnAuthenticated(message: failure.message!)),
              (response) async {
        if (response.statusCode == StatusCode.ok) {
          authenticatedUser = response.data;

          if (credentialsIsSaved) {
            await saveLoginCredentials
                .call(SaveLoginCredentialsParams(user: authenticatedUser!));
          }
          await updateToken(authenticatedUser!.accessToken!);

          emit(Authenticated(authenticatedUser: authenticatedUser));
        } else {
          emit(UnAuthenticated(message: response.message!));
        }
      });
    } else {
      emit(LoginValidatation(isValidate: true));
    }
  }

  void changeLoadingView() {
    isloading = !isloading;
    emit(LoginLoading(isloading));
  }

  Future<void> loginWitSocialMedia({
    required String email,
    required String displayName,
    required int isGoogle,
    required String socialId,
    required bool credentialsIsSaved,
  }) async {
    emit(LoginLoading(isloading));

    final fcmToken = (await _notificationService.getFcmToken())!;
    final Either<Failure, BaseResponse> response =
        await loginWithSoialMediaUseCase.call(
      LoginWithSoialMediaParams(
          email: email,
          displayName: displayName,
          isGoogle: isGoogle,
          socialId: socialId,
          fcmToken: fcmToken,),
    );
    response.fold((failure) => emit(UnAuthenticated(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        authenticatedUser = response.data;
        await updateToken(authenticatedUser!.accessToken!);

        if (credentialsIsSaved) {
          await saveLoginCredentials
              .call(SaveLoginCredentialsParams(user: authenticatedUser!));
        }

        emit(Authenticated(authenticatedUser: authenticatedUser));
      } else {
        emit(UnAuthenticated(message: response.message!));
      }
    });
  }

  Future<void> logout({required BuildContext context}) async {
    final Either<Failure, bool> response = await logoutUseCase.call(NoParams());
    response.fold(
        (falilure) => emit(UnAuthenticated(message: AppStrings.serverFailure)),
        (response) {
      emit(
        UnAuthenticated(
          message: AppLocalizations.of(context)!.translate('logout')!,
        ),
      );
      logoutUseCase.call(NoParams());
      authenticatedUser = null;
           pushNavigateAndRemoveUntil(context, const LoginScreen());
 
    });
  }

  Future<void> deleteAccount({
    required BuildContext context,
    required String accessToken,
  }) async {
    final Either<Failure, BaseResponse> response =
        await deleteAccountUseCase.call(
      DeleteAccountParams(
        accessToken: accessToken,
      ),
    );
    response.fold((failure) => emit(UnAuthenticated(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        authenticatedUser = null;
         pushNavigateAndRemoveUntil(context, const LoginScreen());
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   Routes.loginRoute,
        //   (Route<dynamic> route) => false,
        // );
        emit(UnAuthenticated(message: response.message!));
      } else {
        emit(UnAuthenticated(message: response.message!));
      }
    });
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      loginWitSocialMedia(
        email: googleUser.email,
        displayName: googleUser.displayName!,
        isGoogle: 0,
        socialId: googleUser.id,
        credentialsIsSaved: true,
      );
    }
  }

  signInWithFaceBook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;

      loginWitSocialMedia(
        email: _userData!['email'],
        displayName: _userData!['name'],
        isGoogle: 1,
        socialId: _userData!['id'],
        credentialsIsSaved: true,
      );
    }
  }
}
