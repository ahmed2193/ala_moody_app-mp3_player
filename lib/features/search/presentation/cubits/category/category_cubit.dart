import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/usecases/get_category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategory getCategoryUseCase;
  CategoryCubit({required this.getCategoryUseCase}) : super(CategoryInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Category> category = [];

  Future<void> getCategory({
    String? accessToken,
  }) async {
    if (state is CategoryIsLoading) return;
    emit(CategoryIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getCategoryUseCase(
      GetCategoryParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => CategoryError(message: failure.message),
          (value) {
        category.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return CategoryLoaded();
      }),
    );
  }

 void clearData() {
    if (category.isNotEmpty) {
      category.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
