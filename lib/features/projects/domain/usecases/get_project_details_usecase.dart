import '../../../../core/result/result.dart';
import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectDetailsUseCase {
  const GetProjectDetailsUseCase(this._repository);

  final ProjectRepository _repository;

  Future<Result<Project>> call(String id) => _repository.getProject(id);
}
