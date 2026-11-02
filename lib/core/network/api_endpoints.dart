abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String projects = '/projects';
  static const String tasks = '/tasks';
  static const String notifications = '/notifications';
  static const String classes = '/classes';
  static const String googleClassroomConnect =
      '/integrations/google-classroom/connect';
  static const String googleClassroomDisconnect =
      '/integrations/google-classroom/disconnect';
  static const String googleClassroomCourses =
      '/integrations/google-classroom/courses';
  static const String googleClassroomImport =
      '/integrations/google-classroom/courses/import';
  static const String googleClassroomSettings =
      '/integrations/google-classroom/settings';
  static const String gradePublications = '/grades/publications';

  static String project(String id) => '/projects/$id';

  static String task(String id) => '/tasks/$id';

  static String notificationRead(String id) => '/notifications/$id/read';

  static String schoolClass(String id) => '/classes/$id';

  static String classMappings(String id) => '/classes/$id/mappings';

  static String classMapping(String classId, String mappingId) =>
      '/classes/$classId/mappings/$mappingId';

  static String classSync(String id) => '/classes/$id/sync';

  static String classCoursework(String id) => '/classes/$id/coursework';

  static String coursework(String id) => '/coursework/$id';

  static String courseworkPolicy(String id) => '/coursework/$id/grade-policy';

  static String courseworkSummary(String id) =>
      '/coursework/$id/publication-summary';

  static String courseworkPreview(String id) =>
      '/coursework/$id/publication-preview';

  static String courseworkResults(String id) => '/coursework/$id/results';

  static String approveGrade(String id) => '/grades/$id/approve';

  static String retryPublication(String id) => '/grades/publications/$id/retry';
}
