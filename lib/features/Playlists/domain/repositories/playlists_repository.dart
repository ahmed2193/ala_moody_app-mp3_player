import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';
import '../usecases/create_playlist.dart';
import '../usecases/edit_playlist.dart';
import '../usecases/remove_playlist.dart';

abstract class PlaylistsRepository {
  Future<Either<Failure, BaseResponse>> getMyplayLists({
    required String accessToken,
    required int pageNo,
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
  Future<Either<Failure, BaseResponse>> createPlaylist({
    required CreatePlaylistParams params,
  });
  Future<Either<Failure, BaseResponse>> editPlaylist({
    required EditPlaylistParams params,
  });
  Future<Either<Failure, BaseResponse>> removePlaylist(
      {required RemovePlaylistParams params,});
}
