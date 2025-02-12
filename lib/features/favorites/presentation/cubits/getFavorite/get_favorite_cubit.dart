import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_favorite.dart';

part 'get_favorite_state.dart';

class GetFavoriteCubit extends Cubit<GetFavoriteState> {
  final GetFavorite getFavoriteUseCase;
  GetFavoriteCubit({required this.getFavoriteUseCase})
      : super(GetFavoriteInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Songs> favorite = [];

  Future<void> getFavorite({
    String? accessToken,
  }) async {
    if (state is GetFavoriteIsLoading) return;
    emit(GetFavoriteIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getFavoriteUseCase(
      GetFavoriteParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => GetFavoriteError(message: failure.message),
          (value) {
        favorite.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return GetFavoriteLoaded();
      }),
    );
  }

  clearData() {
    if (favorite.isNotEmpty) {
      favorite.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
