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
import '../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../features/notifications/data/repositories/notification_repository_impl.dart';
import '../features/notifications/domain/repositories/notification_repository.dart';
import '../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../features/notifications/presentation/cubit/notifications_cubit.dart';
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

  getIt.registerLazySingleton(() => ThemeCubit(getIt()));
}
