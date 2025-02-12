import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class AudioPlaylistsRepository {
  Future<Either<Failure, BaseResponse>> getAudioPlaylists({
    required String accessToken,
    required int id,
    required int pageNo,
  });
}
