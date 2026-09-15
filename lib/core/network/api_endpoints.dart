abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String projects = '/projects';
  static const String tasks = '/tasks';
  static const String notifications = '/notifications';

  static String project(String id) => '/projects/$id';

  static String task(String id) => '/tasks/$id';

  static String notificationRead(String id) => '/notifications/$id/read';
}
