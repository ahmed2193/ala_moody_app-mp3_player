part of 'radio_category_cubit.dart';

abstract class RadioCategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class RadioCategoryInitial extends RadioCategoryState {}

class RadioCategoryLoading extends RadioCategoryState {
  RadioCategoryLoading();
  @override
  List<Object> get props => [];
}

class RadioCategorySuccess extends RadioCategoryState {
  RadioCategorySuccess();
  @override
  List<Object> get props => [];
}

class RadioCategoryError extends RadioCategoryState {
  final String message;
  RadioCategoryError({required this.message});
  @override
  List<Object> get props => [message];
}
