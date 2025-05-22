part of 'follow_and_unfollow_cubit.dart';

abstract class FollowAndUnFollowState extends Equatable {
  @override
  List<Object> get props => [];
}

class FollowAndUnFollowInitial extends FollowAndUnFollowState {}

class FollowAndUnFollowLoading extends FollowAndUnFollowState {
  int? id;
  FollowAndUnFollowLoading({this.id});
  @override
  List<Object> get props => [];
}

class FollowAndUnFollowSuccess extends FollowAndUnFollowState {
  final String message;
  FollowAndUnFollowSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class FollowAndUnFollowFailed extends FollowAndUnFollowState {
  final String message;
  int? id;

  FollowAndUnFollowFailed({required this.message,this.id});
  @override
  List<Object> get props => [message];
}
