import 'package:shared_preferences/shared_preferences.dart';

import '../errors/exceptions.dart';

abstract class LocalPreferences {
  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<void> remove(String key);
}

class SharedLocalPreferences implements LocalPreferences {
  SharedLocalPreferences(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> getString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (error) {
      throw CacheException('Unable to read $key.');
    }
  }

  @override
  Future<void> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (error) {
      throw CacheException('Unable to write $key.');
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (error) {
      throw CacheException('Unable to remove $key.');
    }
  }
}
