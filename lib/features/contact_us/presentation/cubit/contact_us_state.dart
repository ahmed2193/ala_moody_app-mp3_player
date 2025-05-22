part of 'contact_us_cubit.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  List<Object?> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsLoaded extends ContactUsState {
  final String message;
  const ContactUsLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}

class ContactUsError extends ContactUsState {
  final String? message;
  const ContactUsError({this.message});
  @override
  List<Object?> get props => [message];
}
