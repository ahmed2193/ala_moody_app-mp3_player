part of 'update_profile_cubit.dart';

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {
  final bool isloading;
  const UpdateProfileLoading(this.isloading);
  @override
  List<Object> get props => [isloading];
}

class UpdateProfileSuccess extends UpdateProfileState {
  // final UserModel? user;
  const UpdateProfileSuccess(
      // {required this.user}
      );

  // @override
  // List<Object> get props => [user!];
}

class UpdateProfileFailed extends UpdateProfileState {
  final String message;
  const UpdateProfileFailed({required this.message});
  @override
  List<Object> get props => [message];
}

class UpdateProfileValidatation extends UpdateProfileState {
  final bool isValidate;
  const UpdateProfileValidatation({required this.isValidate});
  @override
  List<Object> get props => [isValidate];
}
