import 'dart:convert';
import 'package:alamoody/features/download_songs/data/models/downloaded_song_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseDownloadedLocalDataSource {
  // Future<bool> saveDownloadedMusic(
  //     {required List<DownloadedMusicModel> savedMusic});
  Future<List<DownloadedMusicModel>> getDownloadedMusic();
  Future<bool> clear();
}

class DownloadedLocalDataSource implements BaseDownloadedLocalDataSource {
  final SharedPreferences sharedPreferences;
  DownloadedLocalDataSource({required this.sharedPreferences});

  @override
  Future<List<DownloadedMusicModel>> getDownloadedMusic() async {
    // sharedPreferences.remove('downloadedMusic');
    if (sharedPreferences.getString('downloadedMusic') != null) {
      final musicData =
          await json.decode(sharedPreferences.getString('downloadedMusic')!);
      return List<DownloadedMusicModel>.from(
        musicData.map((d) => DownloadedMusicModel.fromJson(d)),
      );
    } else {
      return [];
    }
  }

  // @override
  // Future<bool> saveDownloadedMusic(
  //         {required List<DownloadedMusicModel> savedMusic}) async =>
  //     sharedPreferences.setString('downloadedMusic', json.encode(savedMusic));
  @override
  Future<bool> clear() async => sharedPreferences.remove('downloadedMusic');
}
