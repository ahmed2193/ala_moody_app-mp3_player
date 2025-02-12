import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'plan_details_state.dart';

class PlanDetailsCubit extends Cubit<PlanDetailsState> {
  PlanDetailsCubit() : super(PlanDetailsInitial());
}
