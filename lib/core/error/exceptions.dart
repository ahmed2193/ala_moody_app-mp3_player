import 'package:equatable/equatable.dart';

import '../utils/app_strings.dart';

class ServerException extends Equatable implements Exception {
  final String? message;

  const ServerException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}

class FetchDataException extends ServerException {
  const FetchDataException()
      : super(AppStrings.errorDuringCommunication);
}

class BadRequestException extends ServerException {
  const BadRequestException() : super(AppStrings.badRequest);
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException() : super(AppStrings.authorization);
}

class NotFoundException extends ServerException {
  const NotFoundException() : super(AppStrings.requestedInfoNotFound);
}

class ConflictException extends ServerException {
  const ConflictException() : super(AppStrings.conflictOccurred);
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException()
      : super(AppStrings.internalServerError);
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException()
      : super(AppStrings.noInternetConnection);
}
class MethodNotAllowedException extends ServerException {
  const MethodNotAllowedException()
      : super(AppStrings.methodNotAllowed,
);
}

class CacheException implements Exception {}
