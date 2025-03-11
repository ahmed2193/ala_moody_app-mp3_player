import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/profile/domain/usecases/get_saved_login_credentials.dart';
import 'package:alamoody/features/profile/domain/usecases/save_login_credentials.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../data/model/user_profile.dart';
import '../../../domain/usecases/get_user_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfile getUserProfileUseCase;
  final GetSavedProfileUseCase getSavedProfileUseCase;
  final SaveProfileUseCase saveProfileUseCase;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.getSavedProfileUseCase,
    required this.saveProfileUseCase,
  }) : super(ProfileInitial());
  UserProfile? userProfileData;

  Future<bool> getUserProfile({required String accessToken}) async {
    emit(ProfileIsLoading());
    final Either<Failure, BaseResponse> response = await getUserProfileUseCase
        .call(GetUserProfileParams(accessToken: accessToken));

    response.fold((failure) => emit(ProfileError(message: failure.message)),
        (userProfile) async {
      userProfileData = userProfile.data;
      // await saveProfileUseCase.call(SaveProfileParams(user: userProfile));

      // debugPrint(userProfileData);

      return emit(ProfileLoaded(userProfile: userProfile.data));
    });
    return true;
  }

  void getSavedProfileData() async {
    final response = await getSavedProfileUseCase.call(NoParams());
    response.fold((failure) => ProfileError(message: failure.message), (user) {
      if (user != null) {
        userProfileData = user;
        // emit(Authenticated(authenticatedUser: authenticatedUser));
      }
    });
  }
}
