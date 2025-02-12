import 'dart:async';
import 'dart:io';

import 'package:alamoody/core/helper/print.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../injection_container.dart' as di;
import '../error/exceptions.dart';
import 'api_consumer.dart';
import 'app_interceptors.dart';
import 'end_points.dart';
import 'status_code.dart';

class DioConsumer extends ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    // Configure Dio client
    (client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..validateStatus = (status) {
        return status != null && status < StatusCode.internalServerError;
      };

    // Add interceptors
    client.interceptors.add(di.sl<AppIntercepters>());
    if (kDebugMode) {
      client.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
       return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool formDataIsEnabled = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.post(
        path,
        data: formDataIsEnabled ? FormData.fromMap(body!) : body,
        options: Options(headers: headers),
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool responseIsParsing = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      printColored('response' * 100);
      printColored(response.statusCode);
      printColored(response);
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  void _handleDioError(DioException error) {
    printColored('error' * 10);
    printColored(error.response?.statusCode);
    printColored(error);
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const FetchDataException();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final errorMessage =
            error.response?.data?.toString() ?? 'Unknown error';

        if (statusCode == null) {
          debugPrint('HTTP error occurred, but status code is null.');
          throw FetchDataException();
        }

        // Handle specific status codes
        switch (statusCode) {
          case StatusCode.badRequest:
            throw const BadRequestException();
          case StatusCode.unauthorized:
          case StatusCode.forbidden:
            throw const UnauthorizedException();
          case StatusCode.notFound:
            // Handle 404 error with logging
            debugPrint(
                'Error 404: Resource not found at ${error.requestOptions.uri}. '
                'Details: $errorMessage');
            throw NotFoundException();
          case StatusCode.conflict:
            throw const ConflictException();
          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
          case StatusCode.methodNotAllowed:
            throw const MethodNotAllowedException();
          default:
            debugPrint(
                'Unhandled HTTP error: $statusCode at ${error.requestOptions.uri}. '
                'Details: $errorMessage');
            throw FetchDataException();
        }

      case DioExceptionType.cancel:
        debugPrint('Request was cancelled.');
        break;

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          throw const NoInternetConnectionException();
        }
        throw const FetchDataException();

      default:
        throw const FetchDataException();
    }
  }
}
