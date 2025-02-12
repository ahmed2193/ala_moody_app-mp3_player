import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/status_code.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../home/data/models/songs_play_lists_model.dart';

abstract class PlayListsRemoteDataSource {
  Future<BaseResponse> getMyplayLists({
    required String accessToken,
    required int pageNo,
  });

  Future<BaseResponse> createPlaylists({
    required String accessToken,
    required String playlistName,
  });
  Future<BaseResponse> addSongToPlayLists({
    required String accessToken,
    required int mediaId,
    required String mediaType,
    required int playListsId,
  });
  Future<BaseResponse> removeSongFromPlayLists({
    required String accessToken,
    required int songId,
    required int playListsId,
  });
}

class PlayListsRemoteDataSourceImpl implements PlayListsRemoteDataSource {
  final ApiConsumer apiConsumer;
  PlayListsRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getMyplayLists({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.myPlaylists,
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];
    baseResponse.data =
        iterable.map((model) => SongsPlayListsModel.fromJson(model)).toList();

    baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
    baseResponse.lastPage = responseJson[AppStrings.data][AppStrings.lastPage];
    return baseResponse;
  }

  @override
  Future<BaseResponse> createPlaylists({
    required String playlistName,
    required String accessToken,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.createPlaylist,
      body: {
        AppStrings.playlistName: playlistName,
      },
      headers: {AppStrings.authorization: accessToken},
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.message = AppStrings.success;
    } else {
      baseResponse.message = responseJson[AppStrings.message];
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> addSongToPlayLists({
    required String accessToken,
    required int mediaId,
    required String mediaType,
    required int playListsId,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.addToPlaylist,
      body: {
        AppStrings.mediaId: mediaId,
        AppStrings.mediaType: mediaType,
        AppStrings.playlistId: playListsId,
      },
      headers: {AppStrings.authorization: accessToken},
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.message = AppStrings.success;
    } else {
      baseResponse.message = responseJson[AppStrings.message];
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> removeSongFromPlayLists({
    required String accessToken,
    required int songId,
    required int playListsId,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.removeFromPlaylist,
      body: {
        AppStrings.songId: songId,
        AppStrings.playlistId: playListsId,
      },
      headers: {AppStrings.authorization: accessToken},
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.message = AppStrings.success;
    } else {
      baseResponse.message = responseJson[AppStrings.message];
    }
    return baseResponse;
  }
}
