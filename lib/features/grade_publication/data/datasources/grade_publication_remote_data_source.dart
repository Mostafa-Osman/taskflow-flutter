import '../../../../core/classroom/enums.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/publication_models.dart';

class GradePublicationRemoteDataSource {
  GradePublicationRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<PublicationPreviewItem>> preview(String courseworkId) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.courseworkPreview(courseworkId),
    );
    final items = response.data!['items'] as List<dynamic>? ?? const [];
    return items.map((item) {
      final json = item as Map<String, dynamic>;
      final result = json['result'] as Map<String, dynamic>;
      return PublicationPreviewItem(
        result: GradingResult(
          id: result['id'] as String,
          courseworkId: result['courseworkId'] as String,
          studentId: result['studentId'] as String?,
          googleUserId: result['googleUserId'] as String?,
          score: (result['score'] as num).toDouble(),
          maxScore: (result['maxScore'] as num).toDouble(),
          approved: result['approved'] == true,
        ),
        eligible: json['eligible'] == true,
        blockedReason: json['blockedReason'] as String?,
      );
    }).toList();
  }

  Future<List<PublicationAttempt>> publish(List<String> resultIds) async {
    final response = await _client.post<List<dynamic>>(
      ApiEndpoints.gradePublications,
      data: {'resultIds': resultIds},
    );
    return (response.data ?? const [])
        .map((item) => _attempt(item as Object))
        .toList();
  }

  Future<PublicationAttempt> retry(String attemptId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.retryPublication(attemptId),
    );
    return _attempt(response.data!);
  }

  Future<Map<String, dynamic>> approve(String resultId) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.approveGrade(resultId),
    );
    return response.data!;
  }

  PublicationAttempt _attempt(Object raw) {
    final json = raw as Map<String, dynamic>;
    return PublicationAttempt(
      id: json['id'] as String,
      gradingResultId: json['gradingResultId'] as String,
      externalSubmissionId: json['externalSubmissionId'] as String?,
      publicationMode: PublicationMode.fromApi(json['publicationMode'] as String?),
      status: PublicationAttemptStatus.fromApi(json['status'] as String?),
      attemptCount: json['attemptCount'] as int? ?? 0,
      externalGradeBefore: (json['externalGradeBefore'] as num?)?.toDouble(),
      requestedGrade: (json['requestedGrade'] as num).toDouble(),
      externalGradeAfter: (json['externalGradeAfter'] as num?)?.toDouble(),
      lastErrorCode: json['lastErrorCode'] as String?,
      lastErrorMessage: json['lastErrorMessage'] as String?,
    );
  }
}
