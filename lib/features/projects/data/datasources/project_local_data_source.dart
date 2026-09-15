import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/local_preferences.dart';
import '../models/project_dto.dart';

abstract class ProjectLocalDataSource {
  Future<void> cacheProjects(List<ProjectDto> projects);

  Future<List<ProjectDto>> readProjects();
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  ProjectLocalDataSourceImpl(this._preferences);

  final LocalPreferences _preferences;

  @override
  Future<void> cacheProjects(List<ProjectDto> projects) async {
    final encoded = jsonEncode(projects.map((item) => item.toJson()).toList());
    await _preferences.setString(StorageKeys.cachedProjects, encoded);
  }

  @override
  Future<List<ProjectDto>> readProjects() async {
    final raw = await _preferences.getString(StorageKeys.cachedProjects);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => ProjectDto.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
