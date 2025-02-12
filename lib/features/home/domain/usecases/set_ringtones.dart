// Save Song on track play
// SetRingtones

import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

class SetRingtones
    implements UseCase<BaseResponse, SetRingtonesParams> {
  final HomeRepository homeRepository;
  SetRingtones({required this.homeRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    SetRingtonesParams params,
  ) async =>
      homeRepository.setRingtones(

        accessToken: params.accessToken,
      );
}

class SetRingtonesParams extends Equatable {

  final String accessToken;

  const SetRingtonesParams({

    required this.accessToken,
  });

  @override
  List<Object> get props => [ accessToken];
}
