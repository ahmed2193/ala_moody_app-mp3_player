import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../features/main/data/datasources/lang_local_data_source.dart';
import '../utils/app_strings.dart';

class AppIntercepters extends Interceptor {
  final LangLocalDataSource langLocalDataSource;

  AppIntercepters({required this.langLocalDataSource});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers[AppStrings.apiKey] = AppStrings.alaMoodyKey;
    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    options.headers[AppStrings.xRequested] = AppStrings.xmlHttpRequest;
    options.headers[AppStrings.accept] = AppStrings.applicationJson;

    final String lang = await langLocalDataSource.getSavedLang();
    options.headers[AppStrings.lang] = lang;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}
