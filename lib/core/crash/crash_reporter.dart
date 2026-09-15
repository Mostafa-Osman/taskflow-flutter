/// Abstraction over Crashlytics / Sentry. Feature code depends on this, not Firebase.
abstract class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });

  Future<void> setUserId(String? userId);
}

class NoOpCrashReporter implements CrashReporter {
  const NoOpCrashReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}
