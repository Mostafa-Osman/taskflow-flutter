import 'task_priority.dart';
import 'task_status.dart';

class TaskFilter {
  const TaskFilter({this.query, this.status, this.priority, this.projectId});

  final String? query;
  final TaskStatus? status;
  final TaskPriority? priority;
  final String? projectId;

  TaskFilter copyWith({
    String? query,
    TaskStatus? status,
    TaskPriority? priority,
    String? projectId,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearProjectId = false,
  }) {
    return TaskFilter(
      query: query ?? this.query,
      status: clearStatus ? null : status ?? this.status,
      priority: clearPriority ? null : priority ?? this.priority,
      projectId: clearProjectId ? null : projectId ?? this.projectId,
    );
  }
}

class GetTasksParams {
  const GetTasksParams({
    this.page = 1,
    this.pageSize = 10,
    this.filter = const TaskFilter(),
  });

  final int page;
  final int pageSize;
  final TaskFilter filter;
}
