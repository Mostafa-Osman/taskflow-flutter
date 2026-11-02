import '../../../../core/classroom/enums.dart';
import '../../domain/entities/coursework_item.dart';

class CourseworkDto {
  const CourseworkDto(this.json);

  final Map<String, dynamic> json;

  factory CourseworkDto.fromJson(Map<String, dynamic> json) =>
      CourseworkDto(json);

  CourseworkItem toEntity() {
    final policy = json['policy'] as Map<String, dynamic>? ?? const {};
    final counts = json['publicationSummary'] as Map<String, dynamic>? ?? const {};
    return CourseworkItem(
      id: json['id'] as String,
      classId: json['classId'] as String,
      connectionId: json['connectionId'] as String?,
      title: json['title'] as String,
      externalTitle: json['externalTitle'] as String?,
      maxPoints: (json['maxPoints'] as num?)?.toDouble() ?? 0,
      externalCourseworkId: json['externalCourseworkId'] as String?,
      capabilityState: CapabilityState.fromApi(
        json['capabilityState'] as String?,
      ),
      checkedAt: json['checkedAt'] == null
          ? null
          : DateTime.tryParse(json['checkedAt'] as String),
      lastErrorMessage: json['lastErrorMessage'] as String?,
      unavailableReason: json['unavailableReason'] as String?,
      policy: CourseworkPolicy(
        courseworkId: policy['courseworkId'] as String? ?? json['id'] as String,
        connectionId: policy['connectionId'] as String?,
        gradeSyncPolicy: CourseworkGradeSyncPolicy.fromApi(
          policy['gradeSyncPolicy'] as String?,
        ),
        effectivePolicy: EffectiveGradeSyncPolicy.fromApi(
          policy['effectivePolicy'] as String?,
        ),
        policyUpdatedBy: policy['policyUpdatedBy'] as String?,
        policyUpdatedAt: policy['policyUpdatedAt'] == null
            ? null
            : DateTime.tryParse(policy['policyUpdatedAt'] as String),
      ),
      counts: PublicationCounts(
        eligibleCount: counts['eligibleCount'] as int? ?? 0,
        blockedCount: counts['blockedCount'] as int? ?? 0,
        pendingCount: counts['pendingCount'] as int? ?? 0,
        successCount: counts['successCount'] as int? ?? 0,
        failedCount: counts['failedCount'] as int? ?? 0,
        conflictCount: counts['conflictCount'] as int? ?? 0,
      ),
    );
  }
}
