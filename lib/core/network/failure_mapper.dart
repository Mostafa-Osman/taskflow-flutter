import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';

abstract final class FailureMapper {
  static Failure from(Object error) {
    if (error is Failure) {
      return error;
    }
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message);
    }
    if (error is ValidationException) {
      return ValidationFailure(error.message);
    }
    if (error is NotFoundException) {
      return NotFoundFailure(error.message);
    }
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    }
    if (error is ServerException) {
      return ServerFailure(error.message);
    }
    if (error is CacheException) {
      return CacheFailure(error.message);
    }
    if (error is DioException) {
      return fromDio(error);
    }
    return const UnknownFailure();
  }

  static Failure fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.transformTimeout:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        return _fromStatus(
          error.response?.statusCode,
          _messageFromBody(error.response?.data) ?? error.message,
        );
      case DioExceptionType.cancel:
        return const UnknownFailure('Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const NetworkFailure('Secure connection failed.');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure();
        }
        return UnknownFailure(error.message ?? 'Something went wrong.');
    }
  }

  static Failure _fromStatus(int? status, String? message) {
    switch (status) {
      case 400:
        return ValidationFailure(message ?? 'Please check your input.');
      case 401:
        return UnauthorizedFailure(message ?? 'Please sign in again.');
      case 404:
        return NotFoundFailure(message ?? 'The requested item was not found.');
      case 500:
      case 502:
      case 503:
        return ServerFailure(message ?? 'The server is unavailable.');
      default:
        return ServerFailure(message ?? 'Unexpected server response.');
    }
  }

  static String? _messageFromBody(Object? data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return null;
  }
}
