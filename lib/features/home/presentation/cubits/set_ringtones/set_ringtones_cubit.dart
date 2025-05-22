import 'package:alamoody/features/home/domain/usecases/set_ringtones.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';

part 'set_ringtones_state.dart';

class SetRingtonesCubit extends Cubit<SetRingtonesState> {
  final SetRingtones setRingtonesUseCase;

  SetRingtonesCubit({
    required this.setRingtonesUseCase,
  }) : super(SetRingtonesInitial());

  Future<void> setRingtones({

    required String accessToken,
  }) async {
    emit(SetRingtonesLoading());
    final Either<Failure, BaseResponse> response =
        await setRingtonesUseCase.call(
      SetRingtonesParams(
        accessToken: accessToken,
     
      ),
    );
    response.fold(
        (failure) => emit(SetRingtonesFailed(message: failure.message!)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(SetRingtonesSuccess(message: response.message!));
      } else {
        emit(SetRingtonesFailed(message: response.message!));
      }
    });
  }
}
