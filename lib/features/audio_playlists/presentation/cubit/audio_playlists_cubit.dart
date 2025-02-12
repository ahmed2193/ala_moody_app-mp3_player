import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../../core/entities/songs.dart';
import '../../../../core/entities/user.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../domain/usecases/get_audio_playlists.dart';

part 'audio_playlists_state.dart';

class AudioPlayListsCubit extends Cubit<AudioPlayListsState> {
  final GetAudioPlaylists getAudioPlayListsUseCase;
  AudioPlayListsCubit({required this.getAudioPlayListsUseCase})
      : super(AudioPlayListsInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Songs> audioPlayLists = [];
  User? user;
  Future<void> getAudioPlayLists({
    String? accessToken,
    int? id,
  }) async {
    if (state is AudioPlayListsIsLoading) return;
    emit(AudioPlayListsIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response =
        await getAudioPlayListsUseCase(
      GetAudioPlaylistsParams(
        accessToken: accessToken!,
        pageNo: pageNo,
        id: id!,
      ),
    );
    emit(
      response.fold((failure) => AudioPlayListsError(message: failure.message),
          (value) {
        // user = value.extraData;
        // audioPlayLists = value.data;
        audioPlayLists.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return AudioPlayListsLoaded();
      }),
    );
  }

  void playSongs(context, int initial, List<Songs> audios) {
    final controller = Provider.of<MainController>(context, listen: false);
    controller.playSong(controller.convertToAudio(audios), initial);
  }

  clearData() {
    if (audioPlayLists.isNotEmpty) {
      audioPlayLists.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
