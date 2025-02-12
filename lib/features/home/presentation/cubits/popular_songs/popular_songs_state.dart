part of 'popular_songs_cubit.dart';

abstract class PopularSongsState extends Equatable {
  const PopularSongsState();

  @override
  List<Object?> get props => [];
}

class PopularSongsInitial extends PopularSongsState {}

class PopularSongsIsLoading extends PopularSongsState {
  final bool isFirstFetch;
  const PopularSongsIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class PopularSongsLoaded extends PopularSongsState {}

class PopularSongsError extends PopularSongsState {
  final String? message;
  const PopularSongsError({this.message});
  @override
  List<Object?> get props => [message];
}
