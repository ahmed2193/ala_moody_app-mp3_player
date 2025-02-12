import 'dart:io';

import 'package:alamoody/features/profile/data/local_datasource/profile_local_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/model/user_profile.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileBaseRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ProfileLocalDataSource profileLocalDataSource;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.profileLocalDataSource,
  });

  @override
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
  }) async {
    try {
      final response = await profileRemoteDataSource.updateUserProfile(
        accessToken: accessToken,
        name: name,
        email: email,
        userName: userName,
        gender: gender,
        birthDate: birthDate,
        bio: bio,
        countryId: countryId,
        profilePhoto: profilePhoto,
        phoneNumber: phoneNumber,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getUserProfile({
    required String accessToken,
  }) async {
    try {
      final response = await profileRemoteDataSource.getUserProfile(
        accessToken: accessToken,
      );
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getSavedProfile() async {
    try {
      final response = await profileLocalDataSource.getSavedProfileData();
      return Right(response);
    } on CacheException {
      return const Left(CacheFailure(message: 'Cache Error'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveProfile({required UserProfile user}) async {
    try {
      final response =
          await profileLocalDataSource.saveProfileData(userProfile: user);
      return Right(response);
    } on CacheException {
      return const Left(CacheFailure(message: 'Cache Error'));
    }
  }
}
