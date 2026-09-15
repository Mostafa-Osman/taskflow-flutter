import '../../../../core/result/result.dart';
import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Result<List<Project>>> getProjects();

  Future<Result<Project>> getProject(String id);
}
