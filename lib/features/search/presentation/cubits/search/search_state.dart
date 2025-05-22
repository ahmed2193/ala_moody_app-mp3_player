part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchIsLoading extends SearchState {
  const SearchIsLoading();

  @override
  List<Object?> get props => [];
}

class SearchLoaded extends SearchState {}

class SearchError extends SearchState {
  final String? message;
  const SearchError({this.message});
  @override
  List<Object?> get props => [message];
}
