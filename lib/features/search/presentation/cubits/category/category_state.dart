part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryIsLoading extends CategoryState {
  final bool isFirstFetch;
  const CategoryIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class CategoryLoaded extends CategoryState {}

class CategoryError extends CategoryState {
  final String? message;
  const CategoryError({this.message});
  @override
  List<Object?> get props => [message];
}
