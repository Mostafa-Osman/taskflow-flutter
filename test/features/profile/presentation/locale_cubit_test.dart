import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/constants/storage_keys.dart';
import 'package:taskflow/features/profile/domain/app_language.dart';
import 'package:taskflow/features/profile/presentation/cubit/locale_cubit.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockLocalPreferences preferences;

  setUp(() {
    preferences = MockLocalPreferences();
    when(() => preferences.getString(any())).thenAnswer((_) async => null);
    when(
      () => preferences.setString(any(), any()),
    ).thenAnswer((_) async {});
  });

  test('defaults to system language', () {
    expect(LocaleCubit(preferences).state, AppLanguage.system);
  });

  blocTest<LocaleCubit, AppLanguage>(
    'load restores a persisted Arabic preference',
    build: () {
      when(
        () => preferences.getString(StorageKeys.locale),
      ).thenAnswer((_) async => AppLanguage.arabic.storageValue);
      return LocaleCubit(preferences);
    },
    act: (cubit) => cubit.load(),
    expect: () => [AppLanguage.arabic],
  );

  blocTest<LocaleCubit, AppLanguage>(
    'setLanguage persists English and updates the cubit',
    build: () => LocaleCubit(preferences),
    act: (cubit) => cubit.setLanguage(AppLanguage.english),
    expect: () => [AppLanguage.english],
    verify: (_) {
      verify(
        () => preferences.setString(
          StorageKeys.locale,
          AppLanguage.english.storageValue,
        ),
      ).called(1);
    },
  );
}
