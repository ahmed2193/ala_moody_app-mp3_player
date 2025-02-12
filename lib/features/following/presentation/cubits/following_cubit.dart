import 'package:alamoody/core/models/artists_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_following.dart';

part 'following_state.dart';

class FollowingCubit extends Cubit<FollowingState> {
  final GetFollowing getFollowingUseCase;
  FollowingCubit({required this.getFollowingUseCase})
      : super(FollowingInitial());

  bool loadMore = false;
  int pageNo = 1;
  int totalPages = 1;
  List<ArtistsModel> following = [];

  Future<void> getFollowing({
    String? accessToken,
  }) async {
    if (state is FollowingIsLoading) return;
    emit(FollowingIsLoading(isFirstFetch: pageNo == 1));
    final Either<Failure, BaseResponse> response = await getFollowingUseCase(
      GetFollowingParams(
        accessToken: accessToken!,
        pageNo: pageNo,
      ),
    );
    emit(
      response.fold((failure) => FollowingError(message: failure.message),
          (value) {

            if (value.message == null) {
          following.addAll(value.data);
          totalPages = value.lastPage!;
          pageNo++;
        } else {
          following = [];
        }
   
        return FollowingLoaded();
      }),
    );
  }

  clearData() {
    if (following.isNotEmpty) {
      following.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
