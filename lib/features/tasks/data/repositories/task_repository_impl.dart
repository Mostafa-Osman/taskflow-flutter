import '../../../../core/network/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/paged_list.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_dto.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._remote);

  final TaskRemoteDataSource _remote;

  @override
  Future<Result<PagedList<Task>>> getTasks(GetTasksParams params) async {
    try {
      final dto = await _remote.getTasks(params);
      return Success(dto.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<Task>> getTask(String id) async {
    try {
      final dto = await _remote.getTask(id);
      return Success(dto.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<Task>> createTask(CreateTaskInput input) async {
    try {
      final dto = await _remote.createTask(input);
      return Success(dto.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<Task>> updateTask(Task task) async {
    try {
      final dto = await _remote.updateTask(TaskDto.fromEntity(task));
      return Success(dto.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<void>> deleteTask(String id) async {
    try {
      await _remote.deleteTask(id);
      return const Success(null);
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<Task>> changeStatus({
    required String id,
    required TaskStatus status,
  }) async {
    try {
      final current = await _remote.getTask(id);
      final updated = await _remote.updateTask(
        TaskDto(
          id: current.id,
          projectId: current.projectId,
          title: current.title,
          description: current.description,
          status: status.apiValue,
          priority: current.priority,
          dueDate: current.dueDate,
          createdAt: current.createdAt,
          updatedAt: current.updatedAt,
        ),
      );
      return Success(updated.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }
}
