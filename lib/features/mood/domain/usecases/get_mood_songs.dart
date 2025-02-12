import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/mood_repository.dart';

class GetMoodSongs implements UseCase<BaseResponse, GetMoodSongsParams> {
  final MoodRepository moodRepository;
  GetMoodSongs({required this.moodRepository});

  @override
  Future<Either<Failure, BaseResponse>> call(
    GetMoodSongsParams params,
  ) =>
      moodRepository.getMoodsongs(
          accessToken: params.accessToken,
          id: params.id,
          pageNo: params.pageNo,);
}

class GetMoodSongsParams extends Equatable {
  final String accessToken;
  final int pageNo;
  final int id;

  const GetMoodSongsParams({
    required this.accessToken,
    required this.pageNo,
    required this.id,
  });

  @override
  List<Object?> get props => [
        accessToken,
        id,
        pageNo,
      ];
}
