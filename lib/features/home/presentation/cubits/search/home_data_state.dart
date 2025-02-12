part of 'home_data_cubit.dart';

abstract class HomeDataState extends Equatable {
  const HomeDataState();

  @override
  List<Object?> get props => [];
}

class HomeDataInitial extends HomeDataState {}

class HomeDataIsLoading extends HomeDataState {
  const HomeDataIsLoading();

  @override
  List<Object?> get props => [];
}

class HomeDataLoaded extends HomeDataState {}

class HomeDataError extends HomeDataState {
  final String? message;
  const HomeDataError({this.message});
  @override
  List<Object?> get props => [message];
}
