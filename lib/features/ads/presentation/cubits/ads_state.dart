part of 'ads_cubit.dart';

abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object?> get props => [];
}

class AdsInitial extends AdsState {}

class AdsIsLoading extends AdsState {}

class AdsLoaded extends AdsState {
  final AdsData? ad;
  const AdsLoaded({this.ad});

  @override
  List<Object?> get props => [ad];
}

class AdsError extends AdsState {
  final String? message;
  const AdsError({this.message});

  @override
  List<Object?> get props => [message];
}
