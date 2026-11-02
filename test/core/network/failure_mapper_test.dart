import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/core/errors/exceptions.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/network/failure_mapper.dart';

void main() {
  RequestOptions options() => RequestOptions(path: '/tasks');

  test('maps 401 responses to UnauthorizedFailure', () {
    final failure = FailureMapper.fromDio(
      DioException(
        requestOptions: options(),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options(),
          statusCode: 401,
          data: {'message': 'Please sign in again.'},
        ),
      ),
    );
    expect(failure, isA<UnauthorizedFailure>());
    expect(failure.message, 'Please sign in again.');
  });

  test('maps connection errors to NetworkFailure', () {
    final failure = FailureMapper.fromDio(
      DioException(
        requestOptions: options(),
        type: DioExceptionType.connectionTimeout,
      ),
    );
    expect(failure, isA<NetworkFailure>());
  });

  test('maps unknown SocketException to NetworkFailure', () {
    final failure = FailureMapper.fromDio(
      DioException(
        requestOptions: options(),
        type: DioExceptionType.unknown,
        error: const SocketException('failed'),
      ),
    );
    expect(failure, isA<NetworkFailure>());
  });

  test('maps 403 responses to ForbiddenFailure', () {
    final failure = FailureMapper.fromDio(
      DioException(
        requestOptions: options(),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options(),
          statusCode: 403,
          data: {'message': 'You cannot publish grades for this class.'},
        ),
      ),
    );
    expect(failure, isA<ForbiddenFailure>());
    expect(failure.message, 'You cannot publish grades for this class.');
  });

  test('maps infrastructure exceptions without leaking Dio types', () {
    expect(
      FailureMapper.from(const ValidationException('bad')),
      isA<ValidationFailure>(),
    );
    expect(FailureMapper.from(const CacheException()), isA<CacheFailure>());
  });
}
