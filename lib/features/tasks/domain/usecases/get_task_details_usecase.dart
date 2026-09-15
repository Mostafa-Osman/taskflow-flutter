import '../../../../core/result/result.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTaskDetailsUseCase {
  const GetTaskDetailsUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<Task>> call(String id) => _repository.getTask(id);
}
