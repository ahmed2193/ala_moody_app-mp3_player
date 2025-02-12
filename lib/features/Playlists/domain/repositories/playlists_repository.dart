import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class PlaylistsRepository {
  Future<Either<Failure, BaseResponse>> getMyplayLists({
    required String accessToken,
    required int pageNo,
  });

  Future<Either<Failure, BaseResponse>> createPlaylists({
    required String accessToken,
    required String playlistName,
  });
  Future<Either<Failure, BaseResponse>> addSongToPlayLists({
    required String accessToken,
    required int mediaId,
    required String mediaType,
    required int playListsId,
  });
  Future<Either<Failure, BaseResponse>> removeSongFromPlayLists({
    required String accessToken,
    required int songId,
    required int playListsId,
  });
}
