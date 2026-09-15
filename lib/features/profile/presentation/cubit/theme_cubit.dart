import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/local_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._preferences) : super(ThemeMode.system);

  final LocalPreferences _preferences;

  Future<void> load() async {
    final raw = await _preferences.getString(StorageKeys.themeMode);
    emit(_fromName(raw));
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(mode);
    await _preferences.setString(StorageKeys.themeMode, mode.name);
  }

  ThemeMode _fromName(String? raw) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.system,
    );
  }
}
