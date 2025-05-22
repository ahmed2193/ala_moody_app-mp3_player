part of 'library_cubit.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryIsLoading extends LibraryState {
  final bool isFirstFetch;
  const LibraryIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class LibraryLoaded extends LibraryState {}

class LibraryError extends LibraryState {
  final String? message;
  const LibraryError({this.message});
  @override
  List<Object?> get props => [message];
}
