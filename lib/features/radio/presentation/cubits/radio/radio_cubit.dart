import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/radio.dart';
import '../../../domain/usecases/get_radio.dart';

part 'radio_state.dart';

class RadioCubit extends Cubit<RadioState> {
  final GetRadio radioUseCase;

  RadioCubit({
    required this.radioUseCase,
  }) : super(RadioInitial());
  List<Radio> radio = [];

  Future<void> getRadio({
    required String accessToken,
  }) async {
    emit(RadioLoading());
    final Either<Failure, BaseResponse> response = await radioUseCase(
      GetRadioParams(
        accessToken: accessToken,
      ),
    );
    emit(
      response.fold((failure) => RadioError(message: failure.message!),
          (value) {
        radio = value.data;
        log('===============${radio[0]}===========');

        return RadioSuccess();
      }),
    );
  }
}
