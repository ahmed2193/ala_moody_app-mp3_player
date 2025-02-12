import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/home_repository.dart';

class HomeDataUseCase implements UseCase<BaseResponse, HomeDataUseCaseParams> {
  final HomeRepository homeDataUseCaseRepository;
  HomeDataUseCase({required this.homeDataUseCaseRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    HomeDataUseCaseParams params,
  ) =>
      homeDataUseCaseRepository.homeData(
        accessToken: params.accessToken,
         searchTxt: params.searchTxt,
      );
}

class HomeDataUseCaseParams extends Equatable {
  final String accessToken;
  final String searchTxt;

  const HomeDataUseCaseParams({
    required this.searchTxt,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
        accessToken,
        searchTxt,
      ];
}
