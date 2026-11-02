import '../../../../core/classroom/enums.dart';

class PublicationCounts {
  const PublicationCounts({
    this.eligibleCount = 0,
    this.blockedCount = 0,
    this.pendingCount = 0,
    this.successCount = 0,
    this.failedCount = 0,
    this.conflictCount = 0,
  });

  final int eligibleCount;
  final int blockedCount;
  final int pendingCount;
  final int successCount;
  final int failedCount;
  final int conflictCount;
}

class CourseworkPolicy {
  const CourseworkPolicy({
    required this.courseworkId,
    required this.gradeSyncPolicy,
    required this.effectivePolicy,
    this.connectionId,
    this.policyUpdatedBy,
    this.policyUpdatedAt,
  });

  final String courseworkId;
  final String? connectionId;
  final CourseworkGradeSyncPolicy gradeSyncPolicy;
  final EffectiveGradeSyncPolicy effectivePolicy;
  final String? policyUpdatedBy;
  final DateTime? policyUpdatedAt;
}

class CourseworkItem {
  const CourseworkItem({
    required this.id,
    required this.classId,
    required this.title,
    required this.maxPoints,
    required this.capabilityState,
    required this.policy,
    required this.counts,
    this.connectionId,
    this.externalCourseworkId,
    this.externalTitle,
    this.checkedAt,
    this.lastErrorMessage,
    this.unavailableReason,
  });

  final String id;
  final String classId;
  final String? connectionId;
  final String title;
  final String? externalTitle;
  final double maxPoints;
  final String? externalCourseworkId;
  final CapabilityState capabilityState;
  final DateTime? checkedAt;
  final String? lastErrorMessage;
  final CourseworkPolicy policy;
  final PublicationCounts counts;
  final String? unavailableReason;
}
