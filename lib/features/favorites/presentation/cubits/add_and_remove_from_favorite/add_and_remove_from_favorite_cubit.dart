import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/api/status_code.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/add_and_remove_from_favorite.dart';

part 'add_and_remove_from_favorite_state.dart';

class AddAndRemoveFromFavoritesCubit
    extends Cubit<AddAndRemoveFromFavoritesState> {
  final AddAndRemoveFromFavorites addAndRemoveFromFavoritesUseCase;

  AddAndRemoveFromFavoritesCubit({
    required this.addAndRemoveFromFavoritesUseCase,
  }) : super(AddAndRemoveFromFavoritesInitial());
  int? type;
  Future<void> addAndRemoveFromFavorites({
    required int id,
    required String accessToken,
    required int favtype,
  }) async {
    emit(AddAndRemoveFromFavoritesLoading(id: id));
    final Either<Failure, BaseResponse> response =
        await addAndRemoveFromFavoritesUseCase.call(
      AddAndRemoveFromFavoritesParams(
        accessToken: accessToken,
        id: id.toString(),
        type: type!.toString(),
      ),
    );
    response.fold(
        (failure) =>
            emit(AddAndRemoveFromFavoritesFailed(message: failure.message!,id: id)),
        (response) async {
      if (response.statusCode == StatusCode.ok) {
        emit(AddAndRemoveFromFavoritesSuccess(message: response.message!));
      } else {
        emit(AddAndRemoveFromFavoritesFailed(message: response.message!,id: id));
      }
    });
  }
}
