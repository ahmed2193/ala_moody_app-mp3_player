part of 'artists_cubit.dart';

abstract class ArtistsState extends Equatable {
  const ArtistsState();

  @override
  List<Object?> get props => [];
}

class ArtistsInitial extends ArtistsState {}

class ArtistsIsLoading extends ArtistsState {
  final bool isFirstFetch;
  const ArtistsIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class ArtistsLoaded extends ArtistsState {}

class ArtistsError extends ArtistsState {
  final String? message;
  const ArtistsError({this.message});
  @override
  List<Object?> get props => [message];
}
