import 'package:dio/dio.dart';

class MyDioClient {
  MyDioClient._();

  static Dio init() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // dio.interceptors.add(HttpFormatter(includeResponseHeaders: false));

    return dio;
  }
}
