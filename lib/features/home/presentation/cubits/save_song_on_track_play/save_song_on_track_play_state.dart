part of 'save_song_on_track_play_cubit.dart';

abstract class SaveSongOnTrackPlayState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveSongOnTrackPlayInitial extends SaveSongOnTrackPlayState {}

class SaveSongOnTrackPlayLoading extends SaveSongOnTrackPlayState {
  SaveSongOnTrackPlayLoading();
  @override
  List<Object> get props => [];
}

class SaveSongOnTrackPlaySuccess extends SaveSongOnTrackPlayState {
  final String message;
  SaveSongOnTrackPlaySuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class SaveSongOnTrackPlayFailed extends SaveSongOnTrackPlayState {
  final String message;
  SaveSongOnTrackPlayFailed({required this.message});
  @override
  List<Object> get props => [message];
}
