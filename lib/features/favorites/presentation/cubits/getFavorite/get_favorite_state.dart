part of 'get_favorite_cubit.dart';

abstract class GetFavoriteState extends Equatable {
  const GetFavoriteState();

  @override
  List<Object?> get props => [];
}

class GetFavoriteInitial extends GetFavoriteState {}

class GetFavoriteIsLoading extends GetFavoriteState {
  final bool isFirstFetch;
  const GetFavoriteIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class GetFavoriteLoaded extends GetFavoriteState {}

class GetFavoriteError extends GetFavoriteState {
  final String? message;
  const GetFavoriteError({this.message});
  @override
  List<Object?> get props => [message];
}
