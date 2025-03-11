import 'package:alamoody/features/Playlists/domain/usecases/create_playlist.dart';
import 'package:alamoody/features/Playlists/domain/usecases/edit_playlist.dart';
import 'package:alamoody/features/Playlists/domain/usecases/remove_playlist.dart';
import 'package:dio/dio.dart';

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

  Future<BaseResponse> createPlaylist({
    required CreatePlaylistParams params,
  });
  Future<BaseResponse> editPlaylists({
    required EditPlaylistParams params,
  });
  Future<BaseResponse> removePlaylist({
    required RemovePlaylistParams params,
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
  Future<BaseResponse> createPlaylist({
    required CreatePlaylistParams params,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.createPlaylist,
            formDataIsEnabled: true,

      body: {
        AppStrings.playlistName: params.playlistName,
        AppStrings.playlistDes: params.playlistDes,
        AppStrings.playlistImage: params.playlistImage,
        if (params.playlistImage != null) ...{
          AppStrings.playlistImage:
              await MultipartFile.fromFile(params.playlistImage!.absolute.path),
        },
      },
      headers: {AppStrings.authorization: params.accessToken},
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

  @override
  Future<BaseResponse> editPlaylists(
      {required EditPlaylistParams params,}) async {
    final response = await apiConsumer.post(
      EndPoints.editPlaylist,
            formDataIsEnabled: true,

      body: {
        AppStrings.title: params.playlistName,
        AppStrings.playlistDes: params.playlistDes,
        AppStrings.playlistImage: params.playlistImage,
        AppStrings.id: params.playlistId,

        if (params.playlistImage != null) ...{
          AppStrings.playlistImage:
              await MultipartFile.fromFile(params.playlistImage!.absolute.path),
        },
      },
      headers: {AppStrings.authorization: params.accessToken},
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == StatusCode.ok) {
      baseResponse.message = AppStrings.success;
       baseResponse.data =
        SongsPlayListsModel.fromJson(responseJson);
    } else {
      baseResponse.message = responseJson[AppStrings.message];
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> removePlaylist(
      {required RemovePlaylistParams params,}) async {
    final response = await apiConsumer.post(
      EndPoints.removePlaylist,
      body: {
        AppStrings.playlistId: params.playlistId,
      },
      headers: {AppStrings.authorization: params.accessToken},
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
