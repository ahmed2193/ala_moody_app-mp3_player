import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/genres_repository.dart';


class GetGenres implements UseCase<BaseResponse, GetGenresParams> {
  final GenresRepository genresRepository;
  GetGenres({required this.genresRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetGenresParams params,
  ) =>
     genresRepository.getGenres(
          accessToken: params.accessToken,
          pageNo: params.pageNo,
         );
}

class GetGenresParams extends Equatable {
  final String accessToken;
  final int pageNo;

  const GetGenresParams(
      {required this.pageNo, required this.accessToken, });

  @override
  List<Object?> get props => [
        accessToken,
        pageNo,
      ];
}
