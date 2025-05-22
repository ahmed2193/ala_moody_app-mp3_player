import 'package:equatable/equatable.dart';

abstract class YourMoodState extends Equatable {
  const YourMoodState();

  @override
  List<Object?> get props => [];
}

class YourMoodInitial extends YourMoodState {}

class YourMoodChangeSelectedMood extends YourMoodState {}

class YourMoodIsLoading extends YourMoodState {
  const YourMoodIsLoading();

  @override
  List<Object?> get props => [];
}

class YourMoodLoaded extends YourMoodState {}

class YourMoodError extends YourMoodState {
  final String? message;
  const YourMoodError({this.message});
  @override
  List<Object?> get props => [message];
}
