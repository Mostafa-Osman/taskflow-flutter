import '../../../../core/classroom/enums.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/coursework_dto.dart';

class CourseworkRemoteDataSource {
  CourseworkRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<CourseworkDto>> getForClass(String classId) async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.classCoursework(classId),
    );
    return (response.data ?? const [])
        .map((item) => CourseworkDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<CourseworkDto> getById(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.courseworkSummary(id),
    );
    return CourseworkDto.fromJson(response.data!);
  }

  Future<Map<String, dynamic>> updatePolicy({
    required String courseworkId,
    required CourseworkGradeSyncPolicy policy,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiEndpoints.courseworkPolicy(courseworkId),
      data: {'gradeSyncPolicy': policy.apiValue},
    );
    return response.data!;
  }
}
