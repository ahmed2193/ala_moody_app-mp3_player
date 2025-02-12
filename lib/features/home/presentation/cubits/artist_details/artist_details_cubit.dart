import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_artists_details.dart';

part 'artist_details_state.dart';

class ArtistDetailsCubit extends Cubit<ArtistDetailsState> {
  final GetArtistDetails artistDetailsUseCase;

  ArtistDetailsCubit({
    required this.artistDetailsUseCase,
  }) : super(ArtistDetailsInitial());
  List<Songs> songs = [];
  bool loadMore = false;

  int pageNo = 1;
  int totalPages = 1;
  Future<void> artistDetails({
    required int id,
    required String accessToken,
  }) async {
    if (state is ArtistDetailsLoading) return;
    emit(ArtistDetailsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await artistDetailsUseCase(
      GetArtistDetailsParams(
        accessToken: accessToken,
        id: id,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => ArtistDetailsError(message: failure.message!),
          (value) {
        // songs = value.data;
        songs.addAll(value.data);

        totalPages = value.lastPage!;
        // totalPages = 0;

        pageNo++;
        // log('===============${songs[0]}===========');
        // .addAll(value.data);
        // totalPages = value.lastPage!;
        // pageNo++;
        return ArtistDetailsSuccess();
      }),
    );
  }

  clearData() {
    if (songs.isNotEmpty) {
      songs.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
