import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/profile/data/model/user_profile.dart';
import 'package:alamoody/features/profile/data/repositories/profile_repository.dart';

import 'package:dartz/dartz.dart';

class GetSavedProfileUseCase implements UseCase<UserProfile?, NoParams> {
  final ProfileBaseRepository profileBaseRepository;
  GetSavedProfileUseCase({required this.profileBaseRepository});

  @override
  Future<Either<Failure, UserProfile?>> call(NoParams noParams) async =>
      profileBaseRepository.getSavedProfile();
}
