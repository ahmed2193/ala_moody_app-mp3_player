import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/follow_and_unfollow.dart';

part 'follow_and_unfollow_state.dart';

class FollowAndUnFollowCubit
    extends Cubit<FollowAndUnFollowState> {
  final FollowAndUnFollow followAndUnFollowUseCase;

  FollowAndUnFollowCubit({
    required this.followAndUnFollowUseCase,
  }) : super(FollowAndUnFollowInitial());
  int? type;
  Future<void> followAndUnFollow({
    required int id,
    required String accessToken,
    required int favtype,
  }) async {
    emit(FollowAndUnFollowLoading(id: id));
    final Either<Failure, BaseResponse> response =
        await followAndUnFollowUseCase.call(
      FollowAndUnFollowParams(
        accessToken: accessToken,
        id: id.toString(),
        type: type!.toString(),
      ),
    );
    response.fold(
        (failure) =>
            emit(FollowAndUnFollowFailed(message: failure.message!,id: id)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(FollowAndUnFollowSuccess(message: response.message!));
      } else {
        emit(FollowAndUnFollowFailed(message: response.message!,id: id));
      }
    });
  }
}
