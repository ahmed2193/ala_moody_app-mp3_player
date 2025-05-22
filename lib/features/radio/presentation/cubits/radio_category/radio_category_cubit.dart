
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/radio_category.dart';
import '../../../domain/usecases/get_radio_categories.dart';

part 'radio_category_state.dart';

class RadioCategoryCubit extends Cubit<RadioCategoryState> {
  final GetRadioCategories radioCategoryUseCase;

  RadioCategoryCubit({
    required this.radioCategoryUseCase,
  }) : super(RadioCategoryInitial());
  List<RadioCategory> radioCategory = [];

  Future<void> getRadioCategory({
    required int id,
    required String accessToken,
  }) async {
    emit(RadioCategoryLoading());
    final Either<Failure, BaseResponse> response = await radioCategoryUseCase(
      GetRadioCategoriesParams(
        accessToken: accessToken,
        id: id,
      ),
    );
    emit(
      response.fold((failure) => RadioCategoryError(message: failure.message!),
          (value) {
                    // log('===============${value.data}===========');

        radioCategory = value.data;
        // .addAll(value.data);
        // totalPages = value.lastPage!;
        // pageNo++;
        return RadioCategorySuccess();
      }),
    );
  }
}
