import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class GetSavedLoginCredentials implements UseCase<UserModel?, NoParams> {
  final AuthRepository authRepository;
  GetSavedLoginCredentials({required this.authRepository});

  @override
  Future<Either<Failure, UserModel?>> call(NoParams noParams) async =>
      authRepository.getSavedLoginCredentials();
}
