import 'package:alamoody/core/utils/bottom_nav_bar/models/persistent-nav-bar-scaffold.widget.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(TabInitial());

  // PersistentTabController to control tab switching
  final PersistentTabController controller = PersistentTabController();

  // Function to change the tab index
  void changeTab(int index) {
    controller.index = index;
    emit(TabChanged(index)); // Update state with new index
  }

  // Function to reset the tab to the first index
  void resetTab() {
    controller.index = 0;
    emit(TabReset());
  }

  // Optionally, you can add other actions like hiding/showing tabs, enabling/disabling actions, etc.
}
