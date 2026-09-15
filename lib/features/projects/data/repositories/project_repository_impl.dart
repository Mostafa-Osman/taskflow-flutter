import '../../../../core/network/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_local_data_source.dart';
import '../datasources/project_remote_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl({
    required ProjectRemoteDataSource remote,
    required ProjectLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final ProjectRemoteDataSource _remote;
  final ProjectLocalDataSource _local;

  @override
  Future<Result<List<Project>>> getProjects() async {
    try {
      final dtos = await _remote.getProjects();
      await _local.cacheProjects(dtos);
      return Success(dtos.map((dto) => dto.toEntity()).toList(growable: false));
    } catch (error) {
      try {
        final cached = await _local.readProjects();
        if (cached.isNotEmpty) {
          return Success(
            cached.map((dto) => dto.toEntity()).toList(growable: false),
          );
        }
      } catch (_) {
        // Fall through to the original failure.
      }
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<Project>> getProject(String id) async {
    try {
      final dto = await _remote.getProject(id);
      return Success(dto.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }
}
