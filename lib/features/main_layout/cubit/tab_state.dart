// tab_state.dart
part of 'tab_cubit.dart';

@immutable
abstract class TabState {}

class TabInitial extends TabState {}

class TabChanged extends TabState {
  final int newIndex;
  TabChanged(this.newIndex);
}

class TabReset extends TabState {}
