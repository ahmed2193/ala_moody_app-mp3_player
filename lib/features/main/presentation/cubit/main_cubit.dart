import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constants.dart';
import '../../../../core/helper/hive_reuse.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());


  static MainCubit get(BuildContext context) => BlocProvider.of(context);

  static bool isDark = true;

  // TODO: to change theme
  Future<void> changeThem()async{
    emit(MainInitial());
    isDark = !isDark;
    HiveReuse.mainBox.put(isDarkBox, isDark);
    debugPrint("isDark: $isDark");
    emit(AppChangeThemeState());
  }
}
