part of 'occasions_cubit.dart';

abstract class OccasionsState extends Equatable {
  const OccasionsState();

  @override
  List<Object?> get props => [];
}

class OccasionsInitial extends OccasionsState {}

class OccasionsIsLoading extends OccasionsState {
  final bool isFirstFetch;
  const OccasionsIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class OccasionsLoaded extends OccasionsState {}

class OccasionsError extends OccasionsState {
  final String? message;
  const OccasionsError({this.message});
  @override
  List<Object?> get props => [message];
}
