import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/entities/songs.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_occasions.dart';

part 'occasions_state.dart';

class OccasionsCubit extends Cubit<OccasionsState> {
  final GetOccasions getOccasionsUseCase;
  OccasionsCubit({required this.getOccasionsUseCase})
      : super(OccasionsInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Songs> occasions = [];

  Future<void> getOccasions({
    String? accessToken,
    String? id,
   required String txt,
  }) async {
    if (state is OccasionsIsLoading) return;
    emit(OccasionsIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getOccasionsUseCase(
      GetOccasionsParams(
        accessToken: accessToken!,
        pageNo: pageNo,
        id: id!,
        txt: txt,
      ),
    );
    emit(
      response.fold((failure) => OccasionsError(message: failure.message),
          (value) {
        if (value.message == null) {
          occasions.addAll(value.data);
          totalPages = value.lastPage!;
          pageNo++;
        } else {
          occasions = [];
        }

        return OccasionsLoaded();
      }),
    );
  }

  clearData() {
    if (occasions.isNotEmpty) {
      occasions.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
