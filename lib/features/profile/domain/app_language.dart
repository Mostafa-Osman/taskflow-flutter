import 'package:flutter/material.dart';

enum AppLanguage {
  system,
  english,
  arabic;

  String get storageValue => name;

  Locale? get locale {
    return switch (this) {
      AppLanguage.system => null,
      AppLanguage.english => const Locale('en'),
      AppLanguage.arabic => const Locale('ar'),
    };
  }

  static AppLanguage fromStorage(String? raw) {
    return AppLanguage.values.firstWhere(
      (language) => language.storageValue == raw,
      orElse: () => AppLanguage.system,
    );
  }
}
