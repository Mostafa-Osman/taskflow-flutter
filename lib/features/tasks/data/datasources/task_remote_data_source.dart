import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/task_filter.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/paged_tasks_dto.dart';
import '../models/task_dto.dart';

abstract class TaskRemoteDataSource {
  Future<PagedTasksDto> getTasks(GetTasksParams params);

  Future<TaskDto> getTask(String id);

  Future<TaskDto> createTask(CreateTaskInput input);

  Future<TaskDto> updateTask(TaskDto task);

  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<PagedTasksDto> getTasks(GetTasksParams params) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.tasks,
      queryParameters: {
        'page': params.page,
        'pageSize': params.pageSize,
        if (params.filter.query != null && params.filter.query!.isNotEmpty)
          'query': params.filter.query,
        if (params.filter.status != null)
          'status': params.filter.status!.apiValue,
        if (params.filter.priority != null)
          'priority': params.filter.priority!.apiValue,
        if (params.filter.projectId != null)
          'projectId': params.filter.projectId,
      },
    );
    return PagedTasksDto.fromJson(response.data!);
  }

  @override
  Future<TaskDto> getTask(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.task(id),
    );
    return TaskDto.fromJson(response.data!);
  }

  @override
  Future<TaskDto> createTask(CreateTaskInput input) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.tasks,
      data: {
        'projectId': input.projectId,
        'title': input.title,
        'description': input.description,
        'status': input.status.apiValue,
        'priority': input.priority.apiValue,
        'dueDate': input.dueDate?.toIso8601String(),
      },
    );
    return TaskDto.fromJson(response.data!);
  }

  @override
  Future<TaskDto> updateTask(TaskDto task) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiEndpoints.task(task.id),
      data: task.toJson(),
    );
    return TaskDto.fromJson(response.data!);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _client.delete<void>(ApiEndpoints.task(id));
  }
}
