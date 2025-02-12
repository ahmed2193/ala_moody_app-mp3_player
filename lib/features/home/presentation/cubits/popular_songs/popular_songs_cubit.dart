import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_popular_songs.dart';

part 'popular_songs_state.dart';

class PopularSongsCubit extends Cubit<PopularSongsState> {
  final GetPopularSongs getPopularSongsUseCase;
  PopularSongsCubit({required this.getPopularSongsUseCase})
      : super(PopularSongsInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Songs> popularSongs = [];

  Future<void> getPopularSongs({
    String? accessToken,
  }) async {
    if (state is PopularSongsIsLoading) return;
    emit(PopularSongsIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getPopularSongsUseCase(
      GetPopularSongsParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => PopularSongsError(message: failure.message),
          (value) {
        popularSongs.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return PopularSongsLoaded();
      }),
    );
  }

  clearData() {
    if (popularSongs.isNotEmpty) {
      popularSongs.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
