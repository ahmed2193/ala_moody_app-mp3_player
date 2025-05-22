part of 'audio_playlists_cubit.dart';

abstract class AudioPlayListsState extends Equatable {
  const AudioPlayListsState();

  @override
  List<Object?> get props => [];
}

class AudioPlayListsInitial extends AudioPlayListsState {}

class AudioPlayListsIsLoading extends AudioPlayListsState {
  final bool isFirstFetch;
  const AudioPlayListsIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class AudioPlayListsLoaded extends AudioPlayListsState {}

class AudioPlayListsError extends AudioPlayListsState {
  final String? message;
  const AudioPlayListsError({this.message});
  @override
  List<Object?> get props => [message];
}
