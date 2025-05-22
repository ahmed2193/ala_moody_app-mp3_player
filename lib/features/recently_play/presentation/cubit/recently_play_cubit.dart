import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recently_play_state.dart';

class RecentlyPlayCubit extends Cubit<RecentlyPlayState> {
  RecentlyPlayCubit() : super(RecentlyPlayInitial());
}
