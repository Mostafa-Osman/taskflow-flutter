import '../../../../core/result/result.dart';
import '../../../../core/utils/paged_list.dart';
import '../entities/task.dart';
import '../entities/task_filter.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  const GetTasksUseCase(this._repository);

  final TaskRepository _repository;

  Future<Result<PagedList<Task>>> call(GetTasksParams params) {
    return _repository.getTasks(params);
  }
}
