// Save Song on track play
// AddAndRemoveFromFavorites

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class AddAndRemoveFromFavorites
    implements UseCase<BaseResponse, AddAndRemoveFromFavoritesParams> {
  final FavoriteRepository favoriteRepository;
  AddAndRemoveFromFavorites({required this.favoriteRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    AddAndRemoveFromFavoritesParams params,
  ) async =>
      favoriteRepository.addAndRemoveFromFavorites(
        type: params.type,
        id: params.id,
        accessToken: params.accessToken,
      );
}

class AddAndRemoveFromFavoritesParams extends Equatable {
  final String type;
  final String id;
  final String accessToken;

  const AddAndRemoveFromFavoritesParams({
    required this.type,
    required this.id,
    required this.accessToken,
  });

  @override
  List<Object> get props => [type, id, accessToken];
}
