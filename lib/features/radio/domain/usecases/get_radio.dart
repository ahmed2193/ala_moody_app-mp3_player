import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/radio_repository.dart';

class GetRadio implements UseCase<BaseResponse, GetRadioParams> {
  final RadioRepository radioRepository;
  GetRadio({required this.radioRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetRadioParams params,
  ) =>
      radioRepository.getRadio(
          accessToken: params.accessToken,
          );
}

class GetRadioParams extends Equatable {
  final String accessToken;


  const GetRadioParams(
      { required this.accessToken, });

  @override
  List<Object?> get props => [
        accessToken,

      ];
}
