import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/entities/artists.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_artists.dart';

part 'artists_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  final GetArtists getArtistsUseCase;
  ArtistsCubit({required this.getArtistsUseCase}) : super(ArtistsInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Artists> artists = [];

  Future<void> getArtists({
    String? accessToken,
  }) async {
    if (state is ArtistsIsLoading) return;
    emit(ArtistsIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getArtistsUseCase(
      GetArtistsParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => ArtistsError(message: failure.message),
          (value) {
        if (value.statusCode == StatusCode.ok) {
          artists.addAll(value.data);
          totalPages = value.lastPage!;
          pageNo++;
          return ArtistsLoaded();
        } else {
          return const ArtistsError(message: 'error');
        }
      }),
    );
  }

  clearData() {
    if (artists.isNotEmpty) {
      artists.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
