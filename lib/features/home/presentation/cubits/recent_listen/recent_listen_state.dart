part of 'recent_listen_cubit.dart';

abstract class RecentListenState extends Equatable {
  const RecentListenState();

  @override
  List<Object?> get props => [];
}

class RecentListenInitial extends RecentListenState {}

class RecentListenIsLoading extends RecentListenState {
  final bool isFirstFetch;
  const RecentListenIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class RecentListenLoaded extends RecentListenState {}

class RecentListenError extends RecentListenState {
  final String? message;
  const RecentListenError({this.message});
  @override
  List<Object?> get props => [message];
}
