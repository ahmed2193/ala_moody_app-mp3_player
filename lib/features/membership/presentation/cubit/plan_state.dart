part of 'plan_cubit.dart';

abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object> get props => [];
}

class PlanInitial extends PlanState {}

class PlanDataLoading extends PlanState {}

class PlanSelected extends PlanState {
  final String? htmlData;
  const PlanSelected({this.htmlData});
  @override
  List<Object> get props => [htmlData!];
}
class SubPlanSelected extends PlanState {
  final String? message;
  const SubPlanSelected({this.message});
  @override
  List<Object> get props => [message!];
}
class SubPlanSelectedLoading extends PlanState {

  @override
  List<Object> get props => [];
}

class PlanDataError extends PlanState {
  final String? message;
  const PlanDataError({this.message});
  @override
  List<Object> get props => [message!];
}

class PlanDataSuccess extends PlanState {
  final PlanListEntity planData;
  const PlanDataSuccess({required this.planData});

  @override
  List<Object> get props => [planData];
}
