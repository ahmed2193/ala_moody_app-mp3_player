part of 'create_live_user_cubit.dart';

abstract class CreateUserIsLiveState extends Equatable {
  const CreateUserIsLiveState();

  @override
  List<Object> get props => [];
}

class CreateUserIsLiveInitial extends CreateUserIsLiveState {}

class CreateUserIsLiveLoading extends CreateUserIsLiveState {

  @override
  List<Object> get props => [];
}

class CreateUserIsLiveSuccess extends CreateUserIsLiveState {
  // final UserModel? user;
  const CreateUserIsLiveSuccess(
      // {required this.user}
      );

  // @override
  // List<Object> get props => [user!];
}

class CreateUserIsLiveFailed extends CreateUserIsLiveState {
  final String message;
  const CreateUserIsLiveFailed({required this.message});
  @override
  List<Object> get props => [message];
}

class CreateUserIsLiveValidatation extends CreateUserIsLiveState {
  final bool isValidate;
  const CreateUserIsLiveValidatation({required this.isValidate});
  @override
  List<Object> get props => [isValidate];
}
