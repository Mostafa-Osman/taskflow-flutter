import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';
import '../errors/exceptions.dart';

abstract class SecureStore {
  Future<void> writeToken(String token);

  Future<String?> readToken();

  Future<void> clearToken();
}

class FlutterSecureStore implements SecureStore {
  FlutterSecureStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> writeToken(String token) async {
    try {
      await _storage.write(key: StorageKeys.authToken, value: token);
    } catch (error) {
      throw const CacheException('Unable to persist session token.');
    }
  }

  @override
  Future<String?> readToken() async {
    try {
      return await _storage.read(key: StorageKeys.authToken);
    } catch (error) {
      throw const CacheException('Unable to read session token.');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await _storage.delete(key: StorageKeys.authToken);
    } catch (error) {
      throw const CacheException('Unable to clear session token.');
    }
  }
}
