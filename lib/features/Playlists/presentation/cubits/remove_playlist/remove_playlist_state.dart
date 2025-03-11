part of 'remove_playlist_cubit.dart';

abstract class RemovePlaylistState extends Equatable {
  @override
  List<Object> get props => [];
}

class RemovePlaylistInitial extends RemovePlaylistState {}

class RemovePlaylistLoading extends RemovePlaylistState {
  RemovePlaylistLoading();
  @override
  List<Object> get props => [];
}

class RemovePlaylistSuccess extends RemovePlaylistState {
  final String message;
  RemovePlaylistSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class RemovePlaylistFailed extends RemovePlaylistState {
  final String message;
  RemovePlaylistFailed({required this.message});
  @override
  List<Object> get props => [message];
}
