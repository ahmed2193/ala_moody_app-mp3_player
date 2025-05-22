part of 'set_ringtones_cubit.dart';

abstract class SetRingtonesState extends Equatable {
  @override
  List<Object> get props => [];
}

class SetRingtonesInitial extends SetRingtonesState {}

class SetRingtonesLoading extends SetRingtonesState {
  SetRingtonesLoading();
  @override
  List<Object> get props => [];
}

class SetRingtonesSuccess extends SetRingtonesState {
  final String message;
  SetRingtonesSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class SetRingtonesFailed extends SetRingtonesState {
  final String message;
  SetRingtonesFailed({required this.message});
  @override
  List<Object> get props => [message];
}
