import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_strings.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<bool> saveLoginCredentials({required UserModel userModel});
  Future<UserModel?> getSavedLoginCredentials();
  Future<bool> logout();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getSavedLoginCredentials() async {
    if (sharedPreferences.getString(AppStrings.user) != null) {
      final userData =
          await json.decode(sharedPreferences.getString(AppStrings.user)!);
      return UserModel.fromJson(userData);
    } else {
      return null;
    }
  }

  @override
  Future<bool> saveLoginCredentials({required UserModel userModel}) async =>
      sharedPreferences.setString(AppStrings.user, json.encode(userModel));
  @override
  Future<bool> logout() async {
    sharedPreferences.remove('userProfile');
    return sharedPreferences.remove(AppStrings.user);
  }
}
