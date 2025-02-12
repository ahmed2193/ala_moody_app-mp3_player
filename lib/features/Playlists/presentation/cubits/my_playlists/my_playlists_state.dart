part of 'my_playlists_cubit.dart';

abstract class MyPlaylistsState extends Equatable {
  const MyPlaylistsState();

  @override
  List<Object?> get props => [];
}

class MyPlaylistsInitial extends MyPlaylistsState {}

class MyPlaylistsIsLoading extends MyPlaylistsState {
  final bool isFirstFetch;
  const MyPlaylistsIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class MyPlaylistsLoaded extends MyPlaylistsState {}

class MyPlaylistsError extends MyPlaylistsState {
  final String? message;
  const MyPlaylistsError({this.message});
  @override
  List<Object?> get props => [message];
}
