part of 'create_playlists_cubit.dart';

abstract class CreatePlaylistsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePlaylistsInitial extends CreatePlaylistsState {}

class CreatePlaylistsLoading extends CreatePlaylistsState {
  CreatePlaylistsLoading();
  @override
  List<Object> get props => [];
}

class CreatePlaylistsSuccess extends CreatePlaylistsState {
  final String message;
  CreatePlaylistsSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class CreatePlaylistsFailed extends CreatePlaylistsState {
  final String message;
  CreatePlaylistsFailed({required this.message});
  @override
  List<Object> get props => [message];
}
