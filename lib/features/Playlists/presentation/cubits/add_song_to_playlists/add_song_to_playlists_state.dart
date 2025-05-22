part of 'add_song_to_playlists_cubit.dart';

abstract class AddSongToPlaylistsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddSongToPlaylistsInitial extends AddSongToPlaylistsState {}

class AddSongToPlaylistsLoading extends AddSongToPlaylistsState {
  final bool isloading;
  AddSongToPlaylistsLoading(this.isloading);
  @override
  List<Object> get props => [isloading];
}

class AddSongToPlaylistsSuccess extends AddSongToPlaylistsState {
  final String message;
  AddSongToPlaylistsSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class AddSongToPlaylistsFailed extends AddSongToPlaylistsState {
  final String message;
  AddSongToPlaylistsFailed({required this.message});
  @override
  List<Object> get props => [message];
}
