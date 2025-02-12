import 'package:alamoody/features/genres/domain/usecases/get_genres.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/entities/songs.dart';
import '../../../../core/error/failures.dart';

part 'genres_state.dart';

class GenresCubit extends Cubit<GenresState> {
  final GetGenres getGenresUseCase;
  GenresCubit({required this.getGenresUseCase})
      : super(GenresInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Songs> genres = [];

  Future<void> getGenres({
    String? accessToken,
  }) async {
    if (state is GenresIsLoading) return;
    emit(GenresIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getGenresUseCase(
      GetGenresParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => GenresError(message: failure.message),
          (value) {
        genres.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return GenresLoaded();
      }),
    );
  }

  clearData() {
    if (genres.isNotEmpty) {
      genres.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
