import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/get_recent_listen.dart';

part 'recent_listen_state.dart';

class RecentListenCubit extends Cubit<RecentListenState> {
  final GetRecentListen getRecentListenUseCase;

  RecentListenCubit({required this.getRecentListenUseCase})
      : super(RecentListenInitial());

  bool loadMore = false;

  int pageNo = 1;
  int totalPages = 1;
  List<Songs> recentListen = [];


Future<void>  getrecentListen({
    String? accessToken,
  }) async {
    if (state is  RecentListenIsLoading) return;
    emit( RecentListenIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getRecentListenUseCase(
      GetRecentListenParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) =>  RecentListenError(message: failure.message),
          (value) {
         recentListen.addAll(value.data);
        totalPages = value.lastPage!;
        pageNo++;
        return  RecentListenLoaded();
      }),
    );
  }


  clearData() {
    if (recentListen.isNotEmpty) {
      recentListen.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
