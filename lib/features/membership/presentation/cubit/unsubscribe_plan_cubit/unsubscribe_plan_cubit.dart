import 'package:alamoody/features/membership/domain/usecases/unsubscribe_plan_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
part 'unsubscribe_plan_state.dart';

class UnsubscribePlanCubit extends Cubit<UnsubscribePlanState> {
  final UnsubscribePlanUseCase unsubscribePlanUseCase;
  UnsubscribePlanCubit({required this.unsubscribePlanUseCase})
      : super(UnsubscribePlanInitial());

  Future<void> unsubscribePlan({
    required String accessToken,
  }) async {
    emit(UnsubscribePlanLoading());
    final Either<Failure, BaseResponse> response =
        await unsubscribePlanUseCase.call(
      UnsubscribePlanParams(
        accessToken: accessToken,
      ),
    );

    response.fold(
        (failure) => emit(UnsubscribePlanFailed(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        // UserModel user = response.data;

        emit(
          UnsubscribePlanSuccess(
              // user: user
              ),
        );
      } else {
        emit(UnsubscribePlanFailed(message: response.message!));
      }
    });
  }
}
