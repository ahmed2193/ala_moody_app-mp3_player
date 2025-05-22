import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/mood_repository.dart';

class GetMood implements UseCase<BaseResponse, GetMoodParams> {
  final MoodRepository moodRepository;
  GetMood({required this.moodRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetMoodParams params,
  ) =>
      moodRepository.getMood(
        accessToken: params.accessToken,
      );
}

class GetMoodParams extends Equatable {
  final String accessToken;

  const GetMoodParams({
    required this.accessToken,
  });

  @override
  List<Object?> get props => [
        accessToken,
      ];
}
