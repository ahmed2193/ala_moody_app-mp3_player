import 'package:alamoody/features/live_stream/domain/usecases/create_user_is_live.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';

part 'create_live_user_state.dart';

class CreateUserIsLiveCubit extends Cubit<CreateUserIsLiveState> {
  final CreateUserIsLive createUserIsLiveUseCase;
  CreateUserIsLiveCubit({required this.createUserIsLiveUseCase})
      : super(CreateUserIsLiveInitial());

  String? isLiveStream;
  Future<void> createUserIsLive({
    required String accessToken,
    required String isLive,
  }) async {
    isLiveStream = isLive;
    emit(CreateUserIsLiveLoading());
    final Either<Failure, BaseResponse> response =
        await createUserIsLiveUseCase.call(
      CreateUserIsLiveParams(
        accessToken: accessToken,
        isLive: isLive,
      ),
    );

    response.fold(
        (failure) => emit(CreateUserIsLiveFailed(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        // UserModel user = response.data;
        emit(
          const CreateUserIsLiveSuccess(
              // user: user
              ),
        );
      } else {
        emit(CreateUserIsLiveFailed(message: response.message!));
      }
    });
  }
}
