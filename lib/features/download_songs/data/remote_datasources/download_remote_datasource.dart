import 'dart:convert';
import 'dart:io';
import 'package:alamoody/core/api/api_consumer.dart';
import 'package:alamoody/core/helper/my_dio_client.dart';
import 'package:alamoody/features/download_songs/data/models/downloaded_song_model.dart';
import 'package:alamoody/features/download_songs/domain/usecases/download_usecase.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseDownloadDataSource {
  Future<void> downloadSongs(DownloadParams params);
}

class DownloadDataSource extends BaseDownloadDataSource {
  DownloadDataSource({
    required this.apiConsumer,
    required this.sharedPreferences,
  });

  final ApiConsumer apiConsumer;
  final SharedPreferences sharedPreferences;

  @override
  Future<void> downloadSongs(DownloadParams params) async {
    // Request necessary permissions
    if (!await _requestPermissions()) {
      print("Storage permission denied.");
      return;
    }

    // Initialize Dio client
    final Dio dio = MyDioClient.init();

    // Configure Dio to bypass SSL verification (optional, use cautiously in production)
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // Add logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        logPrint: (log) => debugPrint(log.toString()),
      ),
    );

    // Get storage path based on the platform
    final String? externalStorageDirPath = await _getStorageDirectoryPath();
    if (externalStorageDirPath == null) {
      print("Failed to get storage directory.");
      return;
    }

    // Define paths for the song file and artwork image
    final String savePath =
        "$externalStorageDirPath/${params.song.id}.${params.song.extension}";
    final String savePathImage =
        "$externalStorageDirPath/image${params.song.id}.jpg";

    try {
      // Download audio file
      await _downloadFile(
        dio,
        params.song.audio!,
        savePath,
        onProgress: (received, total) {
          if (total != -1) {
            print(
                "${(received / total * 100).toStringAsFixed(0)}% downloaded.");
            double progress = (received / total) * 100;
            params.onProgress(progress);
          }
        },
      );

      // Download artwork image
      await _downloadFile(dio, params.song.artworkUrl!, savePathImage);

      // Save downloaded song data to the song list
      params.songsList.add(
        DownloadedMusicModel(
          title: params.song.title,
          id: params.song.id,
          path: savePath,
          image: savePathImage,
          artists: params.song.artists![0].name ?? '',
          date: DateTime.now().toString(),
        ),
      );

      // Persist downloaded songs to SharedPreferences
      sharedPreferences.setString(
        'downloadedMusic',
        json.encode(params.songsList),
      );
    } on DioException catch (e) {
      print("Download failed: ${e.type} - ${e.message}");
      if (e.response != null) {
        print("Response data: ${e.response?.data}");
      }
    } catch (e) {
      print("Unexpected error: $e");
    }
  }

  /// Request storage permission
  Future<bool> _requestPermissions() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Get the appropriate storage directory path based on the platform
  Future<String?> _getStorageDirectoryPath() async {
    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        return directory?.path;
      } catch (e) {
        print("Error getting external storage directory: $e");
        return null;
      }
    } else if (Platform.isIOS) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
      } catch (e) {
        print("Error getting documents directory: $e");
        return null;
      }
    }
    return null;
  }

  /// Download a file with Dio and optional progress callback
  Future<void> _downloadFile(
    Dio dio,
    String url,
    String savePath, {
    ProgressCallback? onProgress,
  }) async {
    try {
      await dio.download(
        url,
        savePath,
        onReceiveProgress: onProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
    } on DioException {
      rethrow;
    }
  }
}
