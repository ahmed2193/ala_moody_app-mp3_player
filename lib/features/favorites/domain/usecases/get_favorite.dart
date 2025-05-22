import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/favorite_repository.dart';

class GetFavorite implements UseCase<BaseResponse, GetFavoriteParams> {
  final FavoriteRepository favoriteRepository;
  GetFavorite({required this.favoriteRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetFavoriteParams params,
  ) =>
      favoriteRepository.getFavorite(
        accessToken: params.accessToken,
        pageNo: params.pageNo,
      );
}

class GetFavoriteParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetFavoriteParams({
    required this.pageNo,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
