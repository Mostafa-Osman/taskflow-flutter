import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  const UpdateTaskUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<Task>> call(Task task) {
    final titleError = Validators.required(task.title, field: 'Title');
    if (titleError != null) {
      return Future.value(Err(ValidationFailure(titleError)));
    }
    return _repository.updateTask(task);
  }
}
