import 'package:dio/dio.dart';

import '../../config/env/app_env.dart';
import '../constants/app_constants.dart';
import '../logging/app_logger.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';
import 'mock_backend_interceptor.dart';
import 'mock_backend_store.dart';

class ApiClient {
  ApiClient({
    required AppEnv env,
    required SecureStore secureStore,
    required AppLogger logger,
    required MockBackendStore mockStore,
    Dio? dio,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: env.apiBaseUrl,
               connectTimeout: AppConstants.requestTimeout,
               receiveTimeout: AppConstants.requestTimeout,
               sendTimeout: AppConstants.requestTimeout,
               headers: const {
                 'Accept': 'application/json',
                 'Content-Type': 'application/json',
               },
             ),
           ) {
    _dio.interceptors.addAll([
      AuthInterceptor(secureStore),
      if (env.enableHttpLogging) LoggingInterceptor(logger),
      if (env.useMockBackend)
        MockBackendInterceptor(env: env, store: mockStore),
    ]);
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {Object? data}) {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> patch<T>(String path, {Object? data}) {
    return _dio.patch<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return _dio.delete<T>(path);
  }
}
