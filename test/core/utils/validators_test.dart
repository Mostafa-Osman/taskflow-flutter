import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty and malformed values', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('jane'), isNotNull);
    });

    test('accepts a normal email', () {
      expect(Validators.email('jane@taskflow.dev'), isNull);
    });
  });

  group('Validators.password', () {
    test('requires eight characters', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('password123'), isNull);
    });
  });

  test('Validators.name requires two characters', () {
    expect(Validators.name('J'), isNotNull);
    expect(Validators.name('Jane'), isNull);
  });
}
