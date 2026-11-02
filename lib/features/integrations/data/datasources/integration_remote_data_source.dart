import '../../../../core/classroom/enums.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../classes/data/models/school_class_dto.dart';
import '../../domain/entities/google_connection.dart';

class IntegrationRemoteDataSource {
  IntegrationRemoteDataSource(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> connect() async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.googleClassroomConnect,
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> disconnect() async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.googleClassroomDisconnect,
    );
    return response.data!['connection'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSettings() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.googleClassroomSettings,
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> updatePolicy(
    ConnectionGradeSyncPolicy policy,
  ) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiEndpoints.googleClassroomSettings,
      data: {'gradeSyncPolicy': policy.apiValue},
    );
    return response.data!;
  }

  Future<List<ExternalCourseOption>> listCourses() async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.googleClassroomCourses,
    );
    return (response.data ?? const []).map((item) {
      final json = item as Map<String, dynamic>;
      return ExternalCourseOption(
        id: json['id'] as String,
        name: json['name'] as String,
        section: json['section'] as String? ?? '',
        room: json['room'] as String? ?? '',
        subject: json['subject'] as String?,
        createdByThisProject: json['createdByThisProject'] == true,
      );
    }).toList();
  }

  Future<List<SchoolClassDto>> importCourses(List<String> courseIds) async {
    final response = await _client.post<List<dynamic>>(
      ApiEndpoints.googleClassroomImport,
      data: {'courseIds': courseIds},
    );
    return (response.data ?? const [])
        .map((item) => SchoolClassDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
