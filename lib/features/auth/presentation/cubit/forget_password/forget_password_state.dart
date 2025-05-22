part of 'forget_password_cubit.dart';

abstract class ForgetPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {
  final bool isloading;
  ForgetPasswordLoading(this.isloading);
  @override
  List<Object> get props => [isloading];
}

class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;
  ForgetPasswordSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class ForgetPasswordFailed extends ForgetPasswordState {
  final String message;
  ForgetPasswordFailed({required this.message});
  @override
  List<Object> get props => [message];
}

class ForgetPasswordValidatation extends ForgetPasswordState {
  final bool isValidate;
  ForgetPasswordValidatation({required this.isValidate});
  @override
  List<Object> get props => [isValidate];
}
