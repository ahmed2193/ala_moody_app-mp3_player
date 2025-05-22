import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'most_popular_state.dart';

class MostPopularCubit extends Cubit<MostPopularState> {
  MostPopularCubit() : super(MostPopularInitial());
}
