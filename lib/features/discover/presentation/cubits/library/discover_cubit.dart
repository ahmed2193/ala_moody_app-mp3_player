import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_discover.dart';

part 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  final GetDiscover getDiscoverUseCase;
  DiscoverCubit({required this.getDiscoverUseCase}) : super(DiscoverInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<Songs> discoverData = [];

  Future<void> getDiscover({
    String? accessToken,
  }) async {
    if (state is DiscoverIsLoading) return;
    emit(DiscoverIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getDiscoverUseCase(
      GetDiscoverParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => DiscoverError(message: failure.message),
          (value) {
        if (value.data != null) {
          discoverData.addAll(value.data);
          totalPages = value.lastPage!;
          pageNo++;
          return DiscoverLoaded();
        }
        print(value.message);
        return DiscoverError(message: value.message);
      }),
    );
  }

  clearData() {
    if (discoverData.isNotEmpty) {
      discoverData.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
