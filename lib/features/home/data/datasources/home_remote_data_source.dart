import 'package:alamoody/core/helper/print.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/status_code.dart';
import '../../../../core/models/artists_model.dart';
import '../../../../core/models/song_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../models/home_model.dart';
import '../models/songs_play_lists_model.dart';

abstract class HomeRemoteDataSource {
  Future<BaseResponse> getplayLists({
    required String accessToken,
    required int pageNo,
  });
  Future<BaseResponse> getPopularSongs({
    required String accessToken,
    required int pageNo,
  });
  Future<BaseResponse> getRecentListen({
    required String accessToken,
    required int pageNo,
  });
  Future<BaseResponse> saveSongOnTrackPlay({
    required String type,
    required String id,
    required String accessToken,
  });

  Future<BaseResponse> getArtists({
    required String accessToken,
    required int pageNo,
  });
  Future<BaseResponse> getArtistDetails({
    required String accessToken,
    required int id,
    required int pageNo,
  });
  Future<BaseResponse> followAndUnFollow({
    required String type,
    required String id,
    required String accessToken,
  });
  Future<BaseResponse> homeData({
    required String accessToken,
    required String searchText,
  });
  Future<BaseResponse> setRingtones({
    required String accessToken,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;
  HomeRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> getplayLists({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.playLists,
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
  Future<BaseResponse> getPopularSongs({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.popularSongs,
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
        iterable.map((model) => SongModel.fromJson(model)).toList();
    baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
    baseResponse.lastPage = responseJson[AppStrings.data][AppStrings.lastPage];
    return baseResponse;
  }

  @override
  Future<BaseResponse> getRecentListen({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.recentListen,
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
        iterable.map((model) => SongModel.fromJson(model)).toList();
    baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
    baseResponse.lastPage = responseJson[AppStrings.data][AppStrings.lastPage];

    return baseResponse;
  }

  @override
  Future<BaseResponse> saveSongOnTrackPlay({
    required String id,
    required String type,
    required String accessToken,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.onTrackPlayed,
      body: {
        AppStrings.id: id,
        AppStrings.type: type,
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
  Future<BaseResponse> getArtistDetails({
    required String accessToken,
    required int id,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.artistDetails + id.toString(),
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    final Iterable iterable =
        responseJson[AppStrings.data][AppStrings.songs][AppStrings.data];
    baseResponse.data =
        iterable.map((model) => SongModel.fromJson(model)).toList();
    baseResponse.currentPage =
        responseJson[AppStrings.data][AppStrings.songs][AppStrings.from];
    baseResponse.lastPage =
        responseJson[AppStrings.data][AppStrings.songs][AppStrings.lastPage];
    return baseResponse;
  }

  @override
  Future<BaseResponse> getArtists({
    required String accessToken,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.artists,
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.pageSize: Constants.fetchLimit,
        AppStrings.pageNumber: pageNo,
      },
    );

    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    if (response.statusCode == 200) {
      final Iterable iterable = responseJson[AppStrings.data][AppStrings.data];
      baseResponse.data =
          iterable.map((model) => ArtistsModel.fromJson(model)).toList();
      baseResponse.currentPage = responseJson[AppStrings.data][AppStrings.from];
      baseResponse.lastPage =
          responseJson[AppStrings.data][AppStrings.lastPage];
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> followAndUnFollow({
    required String type,
    required String id,
    required String accessToken,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.followAndUnFollow,
      body: {
        AppStrings.artistId: id,
        AppStrings.action: type,
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
  Future<BaseResponse> homeData({
    required String accessToken,
    required String searchText,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.homepage,
      headers: {AppStrings.authorization: accessToken},
      queryParameters: {
        AppStrings.search: searchText,
      },
    );
    printColored(response.statusCode * 10);
    final BaseResponse baseResponse =
        BaseResponse(statusCode: response.statusCode);
    final responseJson = Constants.decodeJson(response);
    baseResponse.data = HomeModel.fromJson(responseJson);

    return baseResponse;
  }

  @override
  Future<BaseResponse> setRingtones({
    required String accessToken,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.ringtones,
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
