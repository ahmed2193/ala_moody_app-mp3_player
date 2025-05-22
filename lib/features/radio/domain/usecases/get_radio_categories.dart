import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/radio_repository.dart';

class GetRadioCategories implements UseCase<BaseResponse, GetRadioCategoriesParams> {
  final RadioRepository radioCategoriesRepository;
  GetRadioCategories({required this.radioCategoriesRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetRadioCategoriesParams params,
  ) =>
      radioCategoriesRepository.getRadioCategories(
          accessToken: params.accessToken,
          id: params.id,
          );
}

class GetRadioCategoriesParams extends Equatable {
  final String accessToken;
  final int id;


  const GetRadioCategoriesParams(
      { required this.accessToken, required this.id, });

  @override
  List<Object?> get props => [
        accessToken,
id,
      ];
}
