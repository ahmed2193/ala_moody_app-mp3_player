
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/search.dart';
import '../../../domain/usecases/search.dart' as search;

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final search.Search searchUseCase;
  SearchCubit({required this.searchUseCase}) : super(SearchInitial());

  SearchData? searchData;

  Future<void> getSearch({
    String? accessToken,
    String? searchTxt,
  }) async {
    emit(const SearchIsLoading());
    final Either<Failure, BaseResponse> response = await searchUseCase(
      search.SearchParams(
        accessToken: accessToken!,
        searchTxt: searchTxt!,
      ),
    );
    emit(
      response.fold((failure) => SearchError(message: failure.message),
          (value) {
        searchData = value.data;

        return SearchLoaded();
      }),
    );
  }
}
