import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, BaseResponse>> getplayLists({
    required String accessToken,
    required int pageNo,
  });
  Future<Either<Failure, BaseResponse>> getPopularSongs({
    required String accessToken,
    required int pageNo,
  });
  Future<Either<Failure, BaseResponse>> getRecentListen({
    required String accessToken,
    required int pageNo,
  });
  Future<Either<Failure, BaseResponse>> saveSongOnTrackPlay({
    required String accessToken,
    required String type,
    required String id,
  });
    Future<Either<Failure, BaseResponse>> getArtists({
    required String accessToken,
    required int pageNo,
  });
    Future<Either<Failure, BaseResponse>> getArtistDetails({
    required String accessToken,
    required int id,
    required int pageNo,
  });
     Future<Either<Failure, BaseResponse>> followAndUnFollow({
    required String accessToken,
    required String type,
    required String id,
  });
    Future<Either<Failure, BaseResponse>> homeData({
    required String accessToken,
    required String searchTxt,
  });
    Future<Either<Failure, BaseResponse>> setRingtones({
    required String accessToken,

  });
}
