import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_mood_songs.dart';

part 'mood_songs_state.dart';

class MoodSongsCubit extends Cubit<MoodSongsState> {
  final GetMoodSongs getMoodSongsUseCase;
  MoodSongsCubit({required this.getMoodSongsUseCase})
      : super(MoodSongsInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Songs> moodSongs = [];

  Future<void> getMoodSongs({
    String? accessToken,
    int? id,
  }) async {
    if (state is MoodSongsIsLoading) return;
    emit(MoodSongsIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getMoodSongsUseCase(
      GetMoodSongsParams(accessToken: accessToken!, pageNo: pageNo, id: id!),
    );
    emit(
      response.fold((failure) => MoodSongsError(message: failure.message),
          (value) {
        moodSongs.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return MoodSongsLoaded();
      }),
    );
  }

  clearData() {
    if (moodSongs.isNotEmpty) {
      moodSongs.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
