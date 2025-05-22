part of 'artist_details_cubit.dart';

abstract class ArtistDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ArtistDetailsInitial extends ArtistDetailsState {}

class ArtistDetailsLoading extends ArtistDetailsState {
    final bool isFirstFetch;
   ArtistDetailsLoading({required this.isFirstFetch});
  @override
  List<Object> get props => [isFirstFetch];
}

class ArtistDetailsSuccess extends ArtistDetailsState {
  ArtistDetailsSuccess();
  @override
  List<Object> get props => [];
}

class ArtistDetailsError extends ArtistDetailsState {
  final String message;
  ArtistDetailsError({required this.message});
  @override
  List<Object> get props => [message];
}
