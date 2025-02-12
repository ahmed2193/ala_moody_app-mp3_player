import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/Songs_PlayLists.dart';
import '../../../domain/usecases/get_play_lists.dart';

part 'play_lists_state.dart';

class PlayListsCubit extends Cubit<PlayListsState> {
  final GetPlaylists getPlayListsUseCase;
  PlayListsCubit({required this.getPlayListsUseCase})
      : super(PlayListsInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<SongsPlayLists> songsPlayLists = [];

  Future<void> getPlayLists({
    String? accessToken,
  }) async {
    if (state is PlayListsIsLoading) return;
    emit(PlayListsIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getPlayListsUseCase(
      GetPlayListsParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => PlayListsError(message: failure.message),
          (value) {
        songsPlayLists.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return PlayListsLoaded();
      }),
    );
  }

  clearData() {
    if (songsPlayLists.isNotEmpty) {
      songsPlayLists.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
