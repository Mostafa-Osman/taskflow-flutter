import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env/app_env.dart';
import '../core/analytics/analytics.dart';
import '../core/crash/crash_reporter.dart';
import '../core/logging/app_logger.dart';
import '../core/network/api_client.dart';
import '../core/network/mock_backend_store.dart';
import '../core/storage/local_preferences.dart';
import '../core/storage/secure_storage.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/usecases/restore_session_usecase.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/classes/data/datasources/class_remote_data_source.dart';
import '../features/classes/data/repositories/class_repository_impl.dart';
import '../features/classes/domain/repositories/class_repository.dart';
import '../features/classes/domain/usecases/class_mapping_usecases.dart';
import '../features/classes/domain/usecases/create_class_usecase.dart';
import '../features/classes/domain/usecases/get_class_details_usecase.dart';
import '../features/classes/domain/usecases/get_classes_usecase.dart';
import '../features/classes/presentation/cubit/class_details_cubit.dart';
import '../features/classes/presentation/cubit/class_form_cubit.dart';
import '../features/classes/presentation/cubit/classes_cubit.dart';
import '../features/coursework/data/datasources/coursework_remote_data_source.dart';
import '../features/coursework/data/repositories/coursework_repository_impl.dart';
import '../features/coursework/domain/repositories/coursework_repository.dart';
import '../features/coursework/domain/usecases/coursework_usecases.dart';
import '../features/coursework/domain/usecases/get_class_coursework_usecase.dart';
import '../features/coursework/presentation/cubit/coursework_cubit.dart';
import '../features/grade_publication/data/datasources/grade_publication_remote_data_source.dart';
import '../features/grade_publication/data/repositories/grade_publication_repository_impl.dart';
import '../features/grade_publication/domain/repositories/grade_publication_repository.dart';
import '../features/grade_publication/domain/usecases/grade_publication_usecases.dart';
import '../features/grade_publication/presentation/cubit/publication_cubit.dart';
import '../features/integrations/data/datasources/integration_remote_data_source.dart';
import '../features/integrations/data/repositories/integration_repository_impl.dart';
import '../features/integrations/domain/repositories/integration_repository.dart';
import '../features/integrations/domain/usecases/integration_usecases.dart';
import '../features/integrations/presentation/cubit/integration_cubit.dart';
import '../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../features/notifications/data/repositories/notification_repository_impl.dart';
import '../features/notifications/domain/repositories/notification_repository.dart';
import '../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../features/profile/presentation/cubit/locale_cubit.dart';
import '../features/profile/presentation/cubit/theme_cubit.dart';
import '../features/projects/data/datasources/project_local_data_source.dart';
import '../features/projects/data/datasources/project_remote_data_source.dart';
import '../features/projects/data/repositories/project_repository_impl.dart';
import '../features/projects/domain/repositories/project_repository.dart';
import '../features/projects/domain/usecases/get_project_details_usecase.dart';
import '../features/projects/domain/usecases/get_projects_usecase.dart';
import '../features/projects/presentation/cubit/project_details_cubit.dart';
import '../features/projects/presentation/cubit/projects_cubit.dart';
import '../features/tasks/data/datasources/task_remote_data_source.dart';
import '../features/tasks/data/repositories/task_repository_impl.dart';
import '../features/tasks/domain/repositories/task_repository.dart';
import '../features/tasks/domain/usecases/change_task_status_usecase.dart';
import '../features/tasks/domain/usecases/create_task_usecase.dart';
import '../features/tasks/domain/usecases/delete_task_usecase.dart';
import '../features/tasks/domain/usecases/get_task_details_usecase.dart';
import '../features/tasks/domain/usecases/get_tasks_usecase.dart';
import '../features/tasks/domain/usecases/update_task_usecase.dart';
import '../features/tasks/presentation/cubit/task_details_cubit.dart';
import '../features/tasks/presentation/cubit/task_form_cubit.dart';
import '../features/tasks/presentation/cubit/tasks_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies(AppEnv env) async {
  if (getIt.isRegistered<AppEnv>()) {
    await getIt.reset();
  }

  getIt.registerSingleton<AppEnv>(env);
  getIt.registerLazySingleton<AppLogger>(() => ConsoleLogger(env));
  getIt.registerLazySingleton<CrashReporter>(NoOpCrashReporter.new);
  getIt.registerLazySingleton<Analytics>(NoOpAnalytics.new);

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<LocalPreferences>(
    () => SharedLocalPreferences(getIt()),
  );
  getIt.registerLazySingleton<SecureStore>(FlutterSecureStore.new);
  getIt.registerLazySingleton<MockBackendStore>(
    () => MockBackendStore(preferences: getIt()),
  );
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      env: getIt(),
      secureStore: getIt(),
      logger: getIt(),
      mockStore: getIt(),
    ),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStore: getIt(), preferences: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: getIt(), local: getIt()),
  );
  getIt.registerFactory(() => LoginUseCase(getIt()));
  getIt.registerFactory(() => RegisterUseCase(getIt()));
  getIt.registerFactory(() => LogoutUseCase(getIt()));
  getIt.registerFactory(() => RestoreSessionUseCase(getIt()));
  getIt.registerLazySingleton(
    () => AuthCubit(
      loginUseCase: getIt(),
      registerUseCase: getIt(),
      logoutUseCase: getIt(),
      restoreSessionUseCase: getIt(),
      logger: getIt(),
      analytics: getIt(),
      crashReporter: getIt(),
    ),
  );

  getIt.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProjectLocalDataSource>(
    () => ProjectLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(remote: getIt(), local: getIt()),
  );
  getIt.registerFactory(() => GetProjectsUseCase(getIt()));
  getIt.registerFactory(() => GetProjectDetailsUseCase(getIt()));
  getIt.registerFactory(() => ProjectsCubit(getIt()));
  getIt.registerFactory(() => ProjectDetailsCubit(getIt()));

  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => GetTasksUseCase(getIt()));
  getIt.registerFactory(() => GetTaskDetailsUseCase(getIt()));
  getIt.registerFactory(() => CreateTaskUseCase(getIt()));
  getIt.registerFactory(() => UpdateTaskUseCase(getIt()));
  getIt.registerFactory(() => DeleteTaskUseCase(getIt()));
  getIt.registerFactory(() => ChangeTaskStatusUseCase(getIt()));
  getIt.registerFactory(() => TasksCubit(getIt()));
  getIt.registerFactory(
    () => TaskDetailsCubit(
      getTask: getIt(),
      changeStatus: getIt(),
      deleteTask: getIt(),
    ),
  );
  getIt.registerFactory(
    () => TaskFormCubit(createTask: getIt(), updateTask: getIt()),
  );

  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => GetNotificationsUseCase(getIt()));
  getIt.registerFactory(() => MarkNotificationReadUseCase(getIt()));
  getIt.registerFactory(
    () => NotificationsCubit(getNotifications: getIt(), markRead: getIt()),
  );

  getIt.registerLazySingleton<ClassRemoteDataSource>(
    () => ClassRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ClassRepository>(
    () => ClassRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => GetClassesUseCase(getIt()));
  getIt.registerFactory(() => GetClassDetailsUseCase(getIt()));
  getIt.registerFactory(() => CreateClassUseCase(getIt()));
  getIt.registerFactory(() => MapClassUseCase(getIt()));
  getIt.registerFactory(() => UnmapClassUseCase(getIt()));
  getIt.registerFactory(() => SyncClassUseCase(getIt()));
  getIt.registerFactory(() => ClassesCubit(getIt()));
  getIt.registerFactory(() => ClassFormCubit(getIt()));
  getIt.registerFactory(
    () => ClassDetailsCubit(
      getClass: getIt(),
      getCoursework: getIt(),
      mapClass: getIt(),
      unmapClass: getIt(),
      syncClass: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => CourseworkRemoteDataSource(getIt()));
  getIt.registerLazySingleton<CourseworkRepository>(
    () => CourseworkRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => GetClassCourseworkUseCase(getIt()));
  getIt.registerFactory(() => GetCourseworkUseCase(getIt()));
  getIt.registerFactory(() => UpdateCourseworkPolicyUseCase(getIt()));
  getIt.registerFactory(
    () => CourseworkCubit(getCoursework: getIt(), updatePolicy: getIt()),
  );

  getIt.registerLazySingleton(() => IntegrationRemoteDataSource(getIt()));
  getIt.registerLazySingleton<IntegrationRepository>(
    () => IntegrationRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => ConnectGoogleClassroomUseCase(getIt()));
  getIt.registerFactory(() => DisconnectGoogleClassroomUseCase(getIt()));
  getIt.registerFactory(() => GetIntegrationSettingsUseCase(getIt()));
  getIt.registerFactory(() => UpdateConnectionPolicyUseCase(getIt()));
  getIt.registerFactory(() => ListExternalCoursesUseCase(getIt()));
  getIt.registerFactory(() => ImportExternalCoursesUseCase(getIt()));
  getIt.registerFactory(
    () => IntegrationCubit(
      connect: getIt(),
      disconnect: getIt(),
      getSettings: getIt(),
      updatePolicy: getIt(),
      listCourses: getIt(),
      importCourses: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GradePublicationRemoteDataSource(getIt()));
  getIt.registerLazySingleton<GradePublicationRepository>(
    () => GradePublicationRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerFactory(() => PreviewPublicationsUseCase(getIt()));
  getIt.registerFactory(() => PublishGradesUseCase(getIt()));
  getIt.registerFactory(() => RetryPublicationUseCase(getIt()));
  getIt.registerFactory(() => ApproveGradeUseCase(getIt()));
  getIt.registerFactory(
    () => PublicationCubit(
      getCoursework: getIt(),
      preview: getIt(),
      publish: getIt(),
      retry: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => ThemeCubit(getIt()));
  getIt.registerLazySingleton(() => LocaleCubit(getIt()));
}
