import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../../home/domain/entities/Songs_PlayLists.dart';
import '../../../domain/usecases/get_my_playlists.dart';

part 'my_playlists_state.dart';

class MyPlaylistsCubit extends Cubit<MyPlaylistsState> {
  final GetMyPlaylists getMyPlaylistsUseCase;
  MyPlaylistsCubit({required this.getMyPlaylistsUseCase})
      : super(MyPlaylistsInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<SongsPlayLists> songsMyPlaylists = [];

  Future<void> getMyPlaylists({
    String? accessToken,
  }) async {
    if (state is MyPlaylistsIsLoading) return;
    emit(MyPlaylistsIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getMyPlaylistsUseCase(
      GetMyPlayListsParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => MyPlaylistsError(message: failure.message),
          (value) {
        songsMyPlaylists.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return MyPlaylistsLoaded();
      }),
    );
  }

  clearData() {
    if (songsMyPlaylists.isNotEmpty) {
      songsMyPlaylists.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
