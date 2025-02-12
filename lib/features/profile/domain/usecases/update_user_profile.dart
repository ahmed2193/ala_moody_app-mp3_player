import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../data/repositories/profile_repository.dart';

class UpdateUserProfile
    implements UseCase<BaseResponse, UpdateUserProfileParams> {
  final ProfileBaseRepository profileRepository;
  UpdateUserProfile({required this.profileRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    UpdateUserProfileParams updateUserProfileParams,
  ) async {
    return profileRepository.updateUserProfile(
      accessToken: updateUserProfileParams.accessToken,
      name: updateUserProfileParams.name,
      email: updateUserProfileParams.email,
      userName: updateUserProfileParams.userName,
      gender: updateUserProfileParams.gender,
      birthDate: updateUserProfileParams.birthDate,
      bio: updateUserProfileParams.bio,
      countryId: updateUserProfileParams.countryId,
      phoneNumber: updateUserProfileParams.phoneNumber,
      profilePhoto: updateUserProfileParams.profilePhoto,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final String accessToken;
  final String email;
  final String name;
  final String userName;
  final String gender;
  final String birthDate;
  final String bio;
  final String countryId;
  final String phoneNumber;

  File? profilePhoto;

  UpdateUserProfileParams({
    required this.accessToken,
    required this.name,
    required this.email,
    required this.userName,
    required this.gender,
    required this.birthDate,
    required this.countryId,
    required this.bio,
    required this.phoneNumber,
    this.profilePhoto,
  });

  @override
  List<Object?> get props => [
        accessToken,
        name,
        email,
        bio,
        userName,
        gender,
        birthDate,
        countryId,
        phoneNumber,
        profilePhoto,
      ];
}
