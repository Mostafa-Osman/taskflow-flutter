import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/analytics/analytics.dart';
import 'package:taskflow/core/crash/crash_reporter.dart';
import 'package:taskflow/core/logging/app_logger.dart';
import 'package:taskflow/core/result/result.dart';
import 'package:taskflow/core/storage/local_preferences.dart';
import 'package:taskflow/core/utils/paged_list.dart';
import 'package:taskflow/features/auth/domain/entities/auth_session.dart';
import 'package:taskflow/features/auth/domain/entities/user.dart';
import 'package:taskflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskflow/features/auth/domain/usecases/login_usecase.dart';
import 'package:taskflow/features/auth/domain/usecases/logout_usecase.dart';
import 'package:taskflow/features/auth/domain/usecases/register_usecase.dart';
import 'package:taskflow/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:taskflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:taskflow/features/projects/domain/entities/project.dart';
import 'package:taskflow/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:taskflow/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:taskflow/features/projects/presentation/cubit/projects_state.dart';
import 'package:taskflow/features/tasks/domain/entities/task.dart';
import 'package:taskflow/features/tasks/domain/entities/task_filter.dart';
import 'package:taskflow/features/tasks/domain/entities/task_priority.dart';
import 'package:taskflow/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';
import 'package:taskflow/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:taskflow/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:taskflow/features/tasks/presentation/cubit/tasks_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTaskRepository extends Mock implements TaskRepository {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}

class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}

class MockGetProjectsUseCase extends Mock implements GetProjectsUseCase {}

class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}

class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}

class MockAppLogger extends Mock implements AppLogger {}

class MockLocalPreferences extends Mock implements LocalPreferences {}

class MockAnalytics extends Mock implements Analytics {}

class MockCrashReporter extends Mock implements CrashReporter {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockProjectsCubit extends MockCubit<ProjectsState>
    implements ProjectsCubit {}

class MockTasksCubit extends MockCubit<TasksState> implements TasksCubit {}

const demoUser = User(
  id: 'u-1',
  name: 'Jane Cooper',
  email: 'jane@taskflow.dev',
);

const demoSession = AuthSession(token: 'tok-1', user: demoUser);

final demoProject = Project(
  id: 'p-1',
  name: 'Mobile App Redesign',
  description: 'Refresh the mobile experience.',
  taskCount: 4,
  completedTaskCount: 1,
  updatedAt: DateTime.utc(2026, 9, 12),
);

final demoTask = Task(
  id: 't-1',
  projectId: 'p-1',
  title: 'Design empty states',
  description: 'Cover empty, error, and loading.',
  status: TaskStatus.todo,
  priority: TaskPriority.high,
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 12),
);

PagedList<Task> pagedTasks(List<Task> items, {bool hasMore = false}) {
  return PagedList<Task>(
    items: items,
    page: 1,
    pageSize: 10,
    total: items.length,
    hasMore: hasMore,
  );
}

void registerFallbackValues() {
  registerFallbackValue(const GetTasksParams());
  registerFallbackValue(const TaskFilter());
  registerFallbackValue(
    const CreateTaskInput(
      projectId: 'p-1',
      title: 'Title',
      description: '',
      status: TaskStatus.todo,
      priority: TaskPriority.medium,
    ),
  );
  registerFallbackValue(demoTask);
  registerFallbackValue(const Success<AuthSession>(demoSession));
  registerFallbackValue(const Success<void>(null));
}
