part of 'add_and_remove_from_favorite_cubit.dart';

abstract class AddAndRemoveFromFavoritesState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddAndRemoveFromFavoritesInitial extends AddAndRemoveFromFavoritesState {}

class AddAndRemoveFromFavoritesLoading extends AddAndRemoveFromFavoritesState {
  int? id;
  AddAndRemoveFromFavoritesLoading({this.id});
  @override
  List<Object> get props => [];
}

class AddAndRemoveFromFavoritesSuccess extends AddAndRemoveFromFavoritesState {
  final String message;
  AddAndRemoveFromFavoritesSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class AddAndRemoveFromFavoritesFailed extends AddAndRemoveFromFavoritesState {
  final String message;
  int? id;

  AddAndRemoveFromFavoritesFailed({required this.message,this.id});
  @override
  List<Object> get props => [message];
}
