part of 'mood_songs_cubit.dart';

abstract class MoodSongsState extends Equatable {
  const MoodSongsState();

  @override
  List<Object?> get props => [];
}

class MoodSongsInitial extends MoodSongsState {}

class MoodSongsIsLoading extends MoodSongsState {
  final bool isFirstFetch;
  const MoodSongsIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class MoodSongsLoaded extends MoodSongsState {}

class MoodSongsError extends MoodSongsState {
  final String? message;
  const MoodSongsError({this.message});
  @override
  List<Object?> get props => [message];
}
