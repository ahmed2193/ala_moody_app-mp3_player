part of 'get_notification_cubit.dart';

abstract class GetNotificationState extends Equatable {
  const GetNotificationState();

  @override
  List<Object?> get props => [];
}

class GetNotificationInitial extends GetNotificationState {}

class GetNotificationIsLoading extends GetNotificationState {
  final bool isFirstFetch;
  const GetNotificationIsLoading({required this.isFirstFetch});

  @override
  List<Object?> get props => [isFirstFetch];
}

class GetNotificationLoaded extends GetNotificationState {}

class GetNotificationError extends GetNotificationState {
  final String? message;
  const GetNotificationError({this.message});
  @override
  List<Object?> get props => [message];
}
