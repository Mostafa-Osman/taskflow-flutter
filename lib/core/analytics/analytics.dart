/// Abstraction over Firebase Analytics / similar. Feature code never imports Firebase.
abstract class Analytics {
  Future<void> logEvent(String name, {Map<String, Object>? parameters});

  Future<void> setUserId(String? userId);
}

class NoOpAnalytics implements Analytics {
  const NoOpAnalytics();

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}
