part of 'discover_cubit.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object?> get props => [];
}

class DiscoverInitial extends DiscoverState {}

class DiscoverIsLoading extends DiscoverState {
  final bool isFirstFetch;
  const DiscoverIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class DiscoverLoaded extends DiscoverState {}

class DiscoverError extends DiscoverState {
  final String? message;
  const DiscoverError({this.message});
  @override
  List<Object?> get props => [message];
}
