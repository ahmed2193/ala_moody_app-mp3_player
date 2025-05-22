// ignore_for_file: avoid_classes_with_only_static_members

import 'package:alamoody/core/helper/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveReuse {
  static Box mainBox = Hive.box(mainBoxName);
}
