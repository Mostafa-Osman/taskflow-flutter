import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/project_dto.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectDto>> getProjects();

  Future<ProjectDto> getProject(String id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  ProjectRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<ProjectDto>> getProjects() async {
    final response = await _client.get<List<dynamic>>(ApiEndpoints.projects);
    return (response.data ?? const [])
        .map((item) => ProjectDto.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<ProjectDto> getProject(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.project(id),
    );
    return ProjectDto.fromJson(response.data!);
  }
}
