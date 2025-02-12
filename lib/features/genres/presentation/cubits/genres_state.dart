part of 'genres_cubit.dart';

abstract class GenresState extends Equatable {
  const GenresState();

  @override
  List<Object?> get props => [];
}

class GenresInitial extends GenresState {}

class GenresIsLoading extends GenresState {
  final bool isFirstFetch;
  const GenresIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class GenresLoaded extends GenresState {}

class GenresError extends GenresState {
  final String? message;
  const GenresError({this.message});
  @override
  List<Object?> get props => [message];
}
