import '../../../../core/result/result.dart';
import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectsUseCase {
  const GetProjectsUseCase(this._repository);

  final ProjectRepository _repository;

  Future<Result<List<Project>>> call() => _repository.getProjects();
}
