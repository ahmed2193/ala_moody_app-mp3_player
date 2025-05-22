import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_library.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final GetLibrary getLibraryUseCase;
  LibraryCubit({required this.getLibraryUseCase}) : super(LibraryInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Songs> library = [];

  Future<void> getLibrary({
    String? accessToken,
    required String type,
  }) async {
    if (state is LibraryIsLoading) return;
    emit(LibraryIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getLibraryUseCase(
      GetLibraryParams(
        accessToken: accessToken!,
        pageNo: pageNo,
        type: type,
      ),
    );
    emit(
      response.fold((failure) => LibraryError(message: failure.message),
          (value) {
        library.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return LibraryLoaded();
      }),
    );
  }

  clearData() {
    if (library.isNotEmpty) {
      library.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
