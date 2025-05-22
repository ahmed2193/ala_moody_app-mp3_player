import 'package:alamoody/features/home/data/models/songs_play_lists_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/base_response.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/models/song_model.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

abstract class AudioPlayListsRemoteDataSource {
  Future<BaseResponse> getAudioPlayLists({
    required String accessToken,
    required int id,
    required int pageNo,
  });
}

class AudioPlayListsRemoteDataSourceImpl
    implements AudioPlayListsRemoteDataSource {
  final ApiConsumer apiConsumer;
  AudioPlayListsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<BaseResponse> getAudioPlayLists({
    required String accessToken,
    required int id,
    required int pageNo,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.playlistAudio + id.toString(),
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
    baseResponse.extraData =
        SongsPlayListsModel.fromJson(responseJson[AppStrings.data]);
    baseResponse.currentPage =
        responseJson[AppStrings.data][AppStrings.songs][AppStrings.from];
    baseResponse.lastPage =
        responseJson[AppStrings.data][AppStrings.songs][AppStrings.lastPage];
    return baseResponse;
  }
}
