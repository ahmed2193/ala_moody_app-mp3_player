import 'package:dartz/dartz.dart';

import '../../../../core/api/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/audio_playlists_repository.dart';
import '../datasources/audio_playlists_remote_data_source.dart';

class AudioPlayListsRepositoryImpl implements AudioPlaylistsRepository {
  final AudioPlayListsRemoteDataSource audioPlayListsRemoteDataSource;

  AudioPlayListsRepositoryImpl({
    required this.audioPlayListsRemoteDataSource,
  });

  @override
  Future<Either<Failure, BaseResponse>> getAudioPlaylists(
      {required String accessToken,
      required int id,
      required int pageNo,}) async {
    try {
      final response = await audioPlayListsRemoteDataSource.getAudioPlayLists(
          accessToken: accessToken, id: id, pageNo: pageNo,);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
