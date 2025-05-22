
abstract class PlaylistState {}
class PlaylistInitial extends PlaylistState {}
class PlaylistLoading extends PlaylistState {}
class PlaylistSuccess extends PlaylistState {
  final String message;
  PlaylistSuccess(this.message);
}
class PlaylistError extends PlaylistState {
  final String error;
  PlaylistError(this.error);
}
