import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/class_filter.dart';
import '../models/school_class_dto.dart';

abstract class ClassRemoteDataSource {
  Future<List<SchoolClassDto>> getClasses(ClassFilter filter);

  Future<SchoolClassDto> getClass(String id);

  Future<SchoolClassDto> createClass(CreateClassInput input);

  Future<SchoolClassDto> mapClass({
    required String classId,
    required String externalCourseId,
    required bool confirmed,
  });

  Future<SchoolClassDto> unmapClass({
    required String classId,
    required String mappingId,
  });

  Future<SchoolClassDto> syncClass(String classId);
}

class ClassRemoteDataSourceImpl implements ClassRemoteDataSource {
  ClassRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<SchoolClassDto>> getClasses(ClassFilter filter) async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.classes,
      queryParameters: {
        if (filter.sourceType != null) 'source': filter.sourceType!.apiValue,
        if (filter.status != null) 'status': filter.status!.apiValue,
        if (filter.subject != null) 'subject': filter.subject,
        if (filter.teacherId != null) 'teacher': filter.teacherId,
        if (filter.organizationId != null) 'organization': filter.organizationId,
        if (filter.connectedOnly) 'connected': 'true',
        if (filter.syncIssuesOnly) 'syncIssue': 'true',
      },
    );
    return (response.data ?? const [])
        .map((item) => SchoolClassDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SchoolClassDto> getClass(String id) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.schoolClass(id),
    );
    return SchoolClassDto.fromJson(response.data!);
  }

  @override
  Future<SchoolClassDto> createClass(CreateClassInput input) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.classes,
      data: {
        'name': input.name,
        'subject': input.subject,
        'description': input.description,
        'organizationId': input.organizationId,
      },
    );
    return SchoolClassDto.fromJson(response.data!);
  }

  @override
  Future<SchoolClassDto> mapClass({
    required String classId,
    required String externalCourseId,
    required bool confirmed,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.classMappings(classId),
      data: {
        'externalCourseId': externalCourseId,
        'confirmed': confirmed,
      },
    );
    return SchoolClassDto.fromJson(response.data!);
  }

  @override
  Future<SchoolClassDto> unmapClass({
    required String classId,
    required String mappingId,
  }) async {
    final response = await _client.delete<Map<String, dynamic>>(
      ApiEndpoints.classMapping(classId, mappingId),
    );
    final data = response.data!;
    return SchoolClassDto.fromJson(data['class'] as Map<String, dynamic>);
  }

  @override
  Future<SchoolClassDto> syncClass(String classId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.classSync(classId),
    );
    return SchoolClassDto.fromJson(response.data!);
  }
}
