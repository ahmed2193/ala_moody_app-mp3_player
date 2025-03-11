import 'package:alamoody/core/utils/bottom_nav_bar/models/persistent-nav-bar-scaffold.widget.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  final PersistentTabController controller;
  final List<GlobalKey<NavigatorState>> navigatorKeys;

  TabCubit() 
    : controller = PersistentTabController(),
      navigatorKeys = List.generate(5, (_) => GlobalKey<NavigatorState>()),
      super(TabInitial());

  void changeTab(int index) {
    controller.index = index;
    emit(TabChanged(index));
  }

  void resetTab() {
    controller.index = 0;
    emit(TabReset());
  }
}