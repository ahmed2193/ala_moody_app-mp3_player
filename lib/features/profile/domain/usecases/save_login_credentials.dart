import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/profile/data/model/user_profile.dart';
import 'package:alamoody/features/profile/data/repositories/profile_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SaveProfileUseCase implements UseCase<bool, SaveProfileParams> {
  final ProfileBaseRepository profileBaseRepository;
  SaveProfileUseCase({required this.profileBaseRepository});

  @override
  Future<Either<Failure, bool>> call(SaveProfileParams params) async =>
      profileBaseRepository.saveProfile(user: params.user);
}

class SaveProfileParams extends Equatable {
  final UserProfile user;

  const SaveProfileParams({
    required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}
