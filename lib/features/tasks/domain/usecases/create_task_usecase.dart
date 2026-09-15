import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTaskUseCase {
  const CreateTaskUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<Task>> call(CreateTaskInput input) {
    final titleError = Validators.required(input.title, field: 'Title');
    final projectError = Validators.required(input.projectId, field: 'Project');
    if (titleError != null || projectError != null) {
      return Future.value(Err(ValidationFailure(titleError ?? projectError!)));
    }
    return _repository.createTask(input);
  }
}
