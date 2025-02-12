import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../../../config/locale/app_localizations.dart';

mixin ValidationMixin<T extends StatefulWidget> on State<T> {
  String? _password;
  // ignore: unused_field
  String? _newPassword;

  String? validateEmail(String? email) {
    if (email!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('email_validation')!;
    } else if (!isEmail(email)) {
      return AppLocalizations.of(context)!.translate('email_not_valid')!;
    }
    return null;
  }

  String? validateUserName(String? userName) {
    if (userName!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('user_name_validation')!;
    }
    return null;
  }

  String? validatePhoneNO(String? phoneNo) {
    if (phoneNo!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('phone_no_validation')!;
    }
    return null;
  }

  String? validateName(String? firstName) {
    if (firstName!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('name_validation')!;
    }
    return null;
  }

  String? validateLastName(String? lastName) {
    if (lastName!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('last_name_validation')!;
    }
    return null;
  }

  String? validatePassword(String? password) {
    _password = password;
    if (password!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('password_validation')!;
    }
    return null;
  }

  String? validateNewPassword(String? newPassword) {
    _newPassword = newPassword;
    if (newPassword!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('new_password_validation')!;
    }
    return null;
  }

  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword!.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('confirm_password_validation')!;
    } else if (_password != confirmPassword) {
      return AppLocalizations.of(context)!.translate( 'password_not_identical')!;
    }
    return null;
  }

  String? validateGender(dynamic gender) {
    if (gender == null) {
      return AppLocalizations.of(context)!.translate('gender_validation')!;
    }
    return null;
  }
}
