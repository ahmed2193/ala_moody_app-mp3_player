part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileIsLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;
  const ProfileLoaded({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

class ProfileError extends ProfileState {
  final String? message;
  const ProfileError({this.message});
  @override
  List<Object?> get props => [message];
}
class ProfilePhotoUpdated extends ProfileState {

}
class ProfileNameUpdated extends ProfileState {
    final String? name;
  const ProfileNameUpdated({this.name});
  @override
  List<Object?> get props => [name];

}
class ProfileUsernameUpdated extends ProfileState {
    final String? username;
  const ProfileUsernameUpdated({this.username});
  @override
  List<Object?> get props => [username];

}
class ProfileMobileUpdated extends ProfileState {
    final String? mobile;
  const ProfileMobileUpdated({this.mobile});
  @override
  List<Object?> get props => [mobile];

}
class ProfileEmailUpdated extends ProfileState {
    final String? email;
  const ProfileEmailUpdated({this.email});
  @override
  List<Object?> get props => [email];

}
class ProfileBioUpdated extends ProfileState {
    final String? bio;
  const ProfileBioUpdated({this.bio});
  @override
  List<Object?> get props => [bio];

}
class ProfileBirthDateUpdated extends ProfileState {
    final String? birthDate;
  const ProfileBirthDateUpdated({this.birthDate});
  @override
  List<Object?> get props => [birthDate];

}
class ProfileGenderUpdated extends ProfileState {
    final String? gender;
  const ProfileGenderUpdated({this.gender});
  @override
  List<Object?> get props => [gender];

}

