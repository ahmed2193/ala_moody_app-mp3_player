part of 'radio_cubit.dart';

abstract class RadioState extends Equatable {
  @override
  List<Object> get props => [];
}

class RadioInitial extends RadioState {}

class RadioLoading extends RadioState {
  RadioLoading();
  @override
  List<Object> get props => [];
}

class RadioSuccess extends RadioState {
  RadioSuccess();
  @override
  List<Object> get props => [];
}

class RadioError extends RadioState {
  final String message;
  RadioError({required this.message});
  @override
  List<Object> get props => [message];
}
