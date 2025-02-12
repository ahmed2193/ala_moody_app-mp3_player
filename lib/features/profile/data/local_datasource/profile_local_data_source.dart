import 'dart:convert';
import 'package:alamoody/features/profile/data/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<bool> saveProfileData({required UserProfile userProfile});
  Future<UserProfile?> getSavedProfileData();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;
  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserProfile?> getSavedProfileData() async {
    if (sharedPreferences.getString('userProfile') != null) {
      final userData =
          await json.decode(sharedPreferences.getString('userProfile')!);
      return UserProfile.fromJson(userData);
    } else {
      return null;
    }
  }

  @override
  Future<bool> saveProfileData({required UserProfile userProfile}) async =>
      sharedPreferences.setString('userProfile', json.encode(userProfile));
}
