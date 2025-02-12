part of 'following_cubit.dart';

abstract class FollowingState extends Equatable {
  const FollowingState();

  @override
  List<Object?> get props => [];
}

class FollowingInitial extends FollowingState {}

class FollowingIsLoading extends FollowingState {
  final bool isFirstFetch;
  const FollowingIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class FollowingLoaded extends FollowingState {}

class FollowingError extends FollowingState {
  final String? message;
  const FollowingError({this.message});
  @override
  List<Object?> get props => [message];
}
