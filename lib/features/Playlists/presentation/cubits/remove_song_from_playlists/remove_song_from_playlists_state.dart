part of 'remove_song_from_playlists_cubit.dart';

abstract class RemoveSongFromPlaylistsState extends Equatable {
  @override
  List<Object> get props => [];
}

class RemoveSongFromPlaylistsInitial extends RemoveSongFromPlaylistsState {}

class RemoveSongFromPlaylistsLoading extends RemoveSongFromPlaylistsState {
  RemoveSongFromPlaylistsLoading();
  @override
  List<Object> get props => [];
}

class RemoveSongFromPlaylistsSuccess extends RemoveSongFromPlaylistsState {
  final String message;
  RemoveSongFromPlaylistsSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class RemoveSongFromPlaylistsFailed extends RemoveSongFromPlaylistsState {
  final String message;
  RemoveSongFromPlaylistsFailed({required this.message});
  @override
  List<Object> get props => [message];
}
