import '../../../../core/result/result.dart';
import '../../../../core/utils/paged_list.dart';
import '../entities/task.dart';
import '../entities/task_filter.dart';
import '../entities/task_priority.dart';
import '../entities/task_status.dart';

abstract class TaskRepository {
  Future<Result<PagedList<Task>>> getTasks(GetTasksParams params);

  Future<Result<Task>> getTask(String id);

  Future<Result<Task>> createTask(CreateTaskInput input);

  Future<Result<Task>> updateTask(Task task);

  Future<Result<void>> deleteTask(String id);

  Future<Result<Task>> changeStatus({
    required String id,
    required TaskStatus status,
  });
}

class CreateTaskInput {
  const CreateTaskInput({
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
  });

  final String projectId;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
}
