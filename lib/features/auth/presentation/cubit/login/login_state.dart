// ignore_for_file: avoid_positional_boolean_parameters

part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {
   bool? isloading;
  LoginLoading(this.isloading);
  @override
  List<Object> get props => [isloading!];
}

class Authenticated extends LoginState {
  final UserModel? authenticatedUser;
  Authenticated({required this.authenticatedUser});
  @override
  List<Object?> get props => [authenticatedUser];
}

class UnAuthenticated extends LoginState {
  final String message;
  UnAuthenticated({required this.message});
  @override
  List<Object> get props => [message];
}

class LoginValidatation extends LoginState {
  final bool isValidate;
  LoginValidatation({required this.isValidate});
  @override
  List<Object> get props => [isValidate];
}
class DeleteAccountLoading extends LoginState {
  DeleteAccountLoading();
  @override
  List<Object> get props => [];
}

class DeleteAccountSuccess extends LoginState {
  final String message;
  DeleteAccountSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class DeleteAccountFailed extends LoginState {
  final String message;
  DeleteAccountFailed({required this.message});
  @override
  List<Object> get props => [message];
}