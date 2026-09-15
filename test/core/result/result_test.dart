import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/result/result.dart';

void main() {
  test('Success folds to the value', () {
    const result = Success<int>(4);
    expect(result.fold((_) => -1, (value) => value), 4);
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, 4);
  });

  test('Err folds to the failure', () {
    const result = Err<int>(NetworkFailure('offline'));
    expect(result.fold((failure) => failure.message, (_) => ''), 'offline');
    expect(result.isFailure, isTrue);
    expect(result.failureOrNull, isA<NetworkFailure>());
  });
}
