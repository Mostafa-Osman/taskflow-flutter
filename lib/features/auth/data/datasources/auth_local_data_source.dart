import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_preferences.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_dto.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheSession({required String token, required UserDto user});

  Future<String?> readToken();

  Future<UserDto?> readUser();

  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required SecureStore secureStore,
    required LocalPreferences preferences,
  }) : _secureStore = secureStore,
       _preferences = preferences;

  final SecureStore _secureStore;
  final LocalPreferences _preferences;

  @override
  Future<void> cacheSession({
    required String token,
    required UserDto user,
  }) async {
    await _secureStore.writeToken(token);
    await _preferences.setString(
      StorageKeys.authUser,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<String?> readToken() => _secureStore.readToken();

  @override
  Future<UserDto?> readUser() async {
    final raw = await _preferences.getString(StorageKeys.authUser);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      return UserDto.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (error) {
      throw const CacheException('Stored profile is unreadable.');
    }
  }

  @override
  Future<void> clear() async {
    await _secureStore.clearToken();
    await _preferences.remove(StorageKeys.authUser);
  }
}
