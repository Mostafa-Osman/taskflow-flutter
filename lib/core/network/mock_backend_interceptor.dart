import 'package:dio/dio.dart';

import '../../config/env/app_env.dart';
import 'mock_backend_store.dart';

class MockBackendInterceptor extends Interceptor {
  MockBackendInterceptor({required this.env, required this.store});

  final AppEnv env;
  final MockBackendStore store;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(env.mockDelay);
    final response = await store.handle(options);
    final status = response.statusCode ?? 500;
    if (status >= 400) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: response,
          type: DioExceptionType.badResponse,
          message: _message(response.data),
        ),
      );
      return;
    }
    handler.resolve(response);
  }

  String _message(Object? data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String) {
        return message;
      }
    }
    return 'Request failed.';
  }
}
