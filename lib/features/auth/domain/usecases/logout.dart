import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;
  Logout({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async =>
      authRepository.logout();
}
