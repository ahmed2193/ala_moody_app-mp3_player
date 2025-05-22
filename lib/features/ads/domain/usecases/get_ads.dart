import 'package:alamoody/features/ads/domain/repositories/ads_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';

class GetAds implements UseCase<BaseResponse, NoParams> {
  final AdsRepository adsRepository;
  GetAds({required this.adsRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    NoParams params,
  ) =>
      adsRepository.getAds(
     
       );
}


