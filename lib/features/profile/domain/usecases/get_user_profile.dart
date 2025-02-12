import 'package:alamoody/core/api/base_response.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../data/model/user_profile.dart';
import '../../data/repositories/profile_repository.dart';

class GetUserProfile implements UseCase<BaseResponse, GetUserProfileParams> {
  final ProfileBaseRepository profileRepository;
  GetUserProfile({required this.profileRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetUserProfileParams params,
  ) =>
      profileRepository.getUserProfile(
        accessToken: params.accessToken,
      );
}

class GetUserProfileParams extends Equatable {
  final String accessToken;

  const GetUserProfileParams({required this.accessToken});

  @override
  List<Object?> get props => [
        accessToken,
      ];
}
