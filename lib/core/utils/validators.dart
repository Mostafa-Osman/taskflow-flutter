abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(
    String? value, {
    String empty = 'Email is required.',
    String invalid = 'Enter a valid email address.',
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return empty;
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      return invalid;
    }
    return null;
  }

  static String? password(
    String? value, {
    String empty = 'Password is required.',
    String tooShort = 'Password must be at least 8 characters.',
  }) {
    final trimmed = value ?? '';
    if (trimmed.isEmpty) {
      return empty;
    }
    if (trimmed.length < 8) {
      return tooShort;
    }
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required.';
    }
    return null;
  }

  static String? name(
    String? value, {
    String empty = 'Name is required.',
    String tooShort = 'Name must be at least 2 characters.',
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return empty;
    }
    if (trimmed.length < 2) {
      return tooShort;
    }
    return null;
  }
}
