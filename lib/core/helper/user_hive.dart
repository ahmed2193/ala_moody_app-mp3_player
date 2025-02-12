// ignore_for_file: avoid_classes_with_only_static_members

import 'package:alamoody/core/helper/constants.dart';
import 'package:alamoody/core/helper/hive_reuse.dart';
import 'package:alamoody/features/main/presentation/screens/auth_screens/data/models/remember_me_model.dart';

class UserHive {
  static Future<void> rememberUserSignup(RememberMeModel model) async {
    HiveReuse.mainBox
      ..put(rememberNameSignupBox, model.username)
      ..put(rememberEmailSignupBox, model.email)
      ..put(rememberPasswordSignupBox, model.password);
  }

  static Future<RememberMeModel> getUserData() async {
    return RememberMeModel(
      username: HiveReuse.mainBox.get(rememberNameSignupBox),
      email: HiveReuse.mainBox.get(rememberEmailSignupBox),
      password: HiveReuse.mainBox.get(rememberPasswordSignupBox),
    );
  }

  static Future<void> clearRememberUserData() async {
    HiveReuse.mainBox
      ..delete(rememberNameSignupBox)
      ..delete(rememberEmailSignupBox)
      ..delete(rememberPasswordSignupBox);
  }
}
