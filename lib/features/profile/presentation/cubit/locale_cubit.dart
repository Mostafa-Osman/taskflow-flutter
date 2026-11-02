import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/local_preferences.dart';
import '../../domain/app_language.dart';

class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit(this._preferences) : super(AppLanguage.system);

  final LocalPreferences _preferences;

  Future<void> load() async {
    final raw = await _preferences.getString(StorageKeys.locale);
    emit(AppLanguage.fromStorage(raw));
  }

  Future<void> setLanguage(AppLanguage language) async {
    emit(language);
    await _preferences.setString(StorageKeys.locale, language.storageValue);
  }
}
