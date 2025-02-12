import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../model/user_profile.dart';

abstract class ProfileBaseRepository {
  Future<Either<Failure, BaseResponse>> getUserProfile({
    required String accessToken,
  });
  Future<Either<Failure, bool>> saveProfile({required UserProfile user});
  Future<Either<Failure, UserProfile?>> getSavedProfile();
  Future<Either<Failure, BaseResponse>> updateUserProfile({
    required String accessToken,
    required String email,
    required String name,
    required String userName,
    required String gender,
    required String birthDate,
    required String bio,
    required String countryId,
    required String phoneNumber,
    File? profilePhoto,
  });
}
