abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const projects = '/projects';
  static const classes = '/classes';
  static const classCreate = '/classes/new';
  static const integrations = '/integrations/google-classroom';
  static const tasks = '/tasks';
  static const profile = '/profile';
  static const notFound = '/404';

  static String projectDetails(String id) => '/projects/$id';

  static String taskDetails(String id) => '/tasks/$id';

  static String taskEdit(String id) => '/tasks/$id/edit';

  static const taskCreate = '/tasks/new';
}
