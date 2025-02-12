part of 'live_users_cubit.dart';

abstract class LiveUsersState extends Equatable {
  @override
  List<Object> get props => [];
}

class LiveUsersInitial extends LiveUsersState {}

class LiveUsersLoading extends LiveUsersState {
  LiveUsersLoading();
  @override
  List<Object> get props => [];
}

class LiveUsersSuccess extends LiveUsersState {
  LiveUsersSuccess();
  @override
  List<Object> get props => [];
}

class LiveUsersError extends LiveUsersState {
  final String message;
  LiveUsersError({required this.message});
  @override
  List<Object> get props => [message];
}
