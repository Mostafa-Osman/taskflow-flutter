import 'classroom_client.dart';
import 'enums.dart';
import 'grade_publication_capability_service.dart';
import 'grade_publication_policy_service.dart';

class PublicationDecision {
  const PublicationDecision.allow() : blockedReason = null;
  const PublicationDecision.deny(this.blockedReason);

  final String? blockedReason;

  bool get allowed => blockedReason == null;
}

class GradePublicationService {
  GradePublicationService({
    required ClassroomClient client,
    required GradePublicationPolicyService policyService,
    required GradePublicationCapabilityService capabilityService,
  }) : _client = client,
       _policyService = policyService,
       _capabilityService = capabilityService;

  final ClassroomClient _client;
  final GradePublicationPolicyService _policyService;
  final GradePublicationCapabilityService _capabilityService;

  PublicationDecision canEnqueue({
    required EffectiveGradeSyncPolicy policy,
    required CapabilityState capability,
    required PublicationMode mode,
    required bool hasPublishPermission,
    required ConnectionStatus connectionStatus,
    required bool approved,
  }) {
    if (!approved) {
      return const PublicationDecision.deny('The local grade is not approved.');
    }
    if (connectionStatus != ConnectionStatus.connected) {
      return PublicationDecision.deny(
        connectionStatus == ConnectionStatus.requiresReauthorization
            ? 'The Google Classroom connection has expired and must be reauthorized.'
            : 'Google Classroom is disconnected.',
      );
    }
    if (capability != CapabilityState.supported) {
      return PublicationDecision.deny(
        _capabilityService.unavailableReason(
              capability: capability,
              policy: policy,
              hasPublishPermission: hasPublishPermission,
              connectionStatus: connectionStatus,
              hasSubmission: true,
              hasConflict: false,
            ) ??
            'Publication is not supported.',
      );
    }
    if (mode == PublicationMode.afterTeacherApproval) {
      if (!_policyService.canCreateAfterApprovalJob(
        policy: policy,
        hasPublishPermission: hasPublishPermission,
      )) {
        return const PublicationDecision.deny(
          'Effective policy does not allow publish-after-approval.',
        );
      }
    } else if (!_policyService.canManuallyPublish(
      policy: policy,
      hasPublishPermission: hasPublishPermission,
    )) {
      return const PublicationDecision.deny(
        'Manual publication is not allowed by policy or permission.',
      );
    }
    return const PublicationDecision.allow();
  }

  Future<Map<String, dynamic>> executeAttempt({
    required Map<String, dynamic> attempt,
    required String courseworkId,
    required String googleUserId,
    required double requestedGrade,
    required String now,
  }) async {
    attempt['status'] = PublicationAttemptStatus.inProgress.apiValue;
    attempt['attemptCount'] = (attempt['attemptCount'] as int? ?? 0) + 1;
    try {
      final submission = await _client.getSubmission(
        courseworkId: courseworkId,
        googleUserId: googleUserId,
      );
      attempt['externalSubmissionId'] = submission.id;
      attempt['externalGradeBefore'] = submission.assignedGrade;
      if (submission.assignedGrade != null &&
          submission.assignedGrade != requestedGrade) {
        attempt['status'] = PublicationAttemptStatus.conflict.apiValue;
        attempt['lastErrorCode'] = 'GRADE_CONFLICT';
        attempt['lastErrorMessage'] =
            'An external grade already exists and was not overwritten.';
        attempt['completedAt'] = now;
        return attempt;
      }
      if (submission.assignedGrade == requestedGrade) {
        attempt['status'] = PublicationAttemptStatus.succeeded.apiValue;
        attempt['externalGradeAfter'] = submission.assignedGrade;
        attempt['lastErrorCode'] = null;
        attempt['lastErrorMessage'] = null;
        attempt['completedAt'] = now;
        return attempt;
      }

      final written = await _client.publishGrade(
        courseworkId: courseworkId,
        googleUserId: googleUserId,
        score: requestedGrade,
      );
      final verified = await _client.getSubmission(
        courseworkId: courseworkId,
        googleUserId: googleUserId,
      );
      if (verified.assignedGrade != written.assignedGrade) {
        attempt['status'] = PublicationAttemptStatus.failed.apiValue;
        attempt['lastErrorCode'] = 'VERIFY_MISMATCH';
        attempt['lastErrorMessage'] =
            'Classroom did not confirm the published grade.';
        attempt['completedAt'] = now;
        return attempt;
      }
      attempt['status'] = PublicationAttemptStatus.succeeded.apiValue;
      attempt['externalGradeAfter'] = verified.assignedGrade;
      attempt['lastErrorCode'] = null;
      attempt['lastErrorMessage'] = null;
      attempt['completedAt'] = now;
      return attempt;
    } on ClassroomClientException catch (error) {
      if (error.code == 'TIMEOUT') {
        try {
          final current = await _client.getSubmission(
            courseworkId: courseworkId,
            googleUserId: googleUserId,
          );
          attempt['externalGradeBefore'] ??= current.assignedGrade;
          if (current.assignedGrade == requestedGrade) {
            attempt['status'] = PublicationAttemptStatus.succeeded.apiValue;
            attempt['externalGradeAfter'] = current.assignedGrade;
            attempt['lastErrorCode'] = null;
            attempt['lastErrorMessage'] = null;
            attempt['completedAt'] = now;
            return attempt;
          }
        } on ClassroomClientException {
          // Keep timeout failure if the read also fails.
        }
      }
      attempt['status'] = PublicationAttemptStatus.failed.apiValue;
      attempt['lastErrorCode'] = error.code;
      attempt['lastErrorMessage'] = error.message;
      attempt['completedAt'] = now;
      return attempt;
    }
  }
}
