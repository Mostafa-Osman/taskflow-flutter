import '../../../../core/result/result.dart';
import '../entities/task.dart';
import '../entities/task_status.dart';
import '../repositories/task_repository.dart';

class ChangeTaskStatusUseCase {
  const ChangeTaskStatusUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<Task>> call({required String id, required TaskStatus status}) {
    return _repository.changeStatus(id: id, status: status);
  }
}
