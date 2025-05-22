part of 'unsubscribe_plan_cubit.dart';

abstract class UnsubscribePlanState extends Equatable {
  @override
  List<Object> get props => [];
}

class UnsubscribePlanInitial extends UnsubscribePlanState {}

class UnsubscribePlanLoading extends UnsubscribePlanState {
  UnsubscribePlanLoading();
  @override
  List<Object> get props => [];
}

class UnsubscribePlanSuccess extends UnsubscribePlanState {
  UnsubscribePlanSuccess();
  @override
  List<Object> get props => [];
}

class UnsubscribePlanFailed extends UnsubscribePlanState {
  final String message;
  UnsubscribePlanFailed({required this.message});
  @override
  List<Object> get props => [message];
}
