part of 'play_lists_cubit.dart';

abstract class PlayListsState extends Equatable {
  const PlayListsState();

  @override
  List<Object?> get props => [];
}

class PlayListsInitial extends PlayListsState {}

class PlayListsIsLoading extends PlayListsState {
  final bool isFirstFetch;
  const PlayListsIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class PlayListsLoaded extends PlayListsState {}

class PlayListsError extends PlayListsState {
  final String? message;
  const PlayListsError({this.message});
  @override
  List<Object?> get props => [message];
}
