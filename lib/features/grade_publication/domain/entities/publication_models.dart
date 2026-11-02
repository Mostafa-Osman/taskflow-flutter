import '../../../../core/classroom/enums.dart';

class GradingResult {
  const GradingResult({
    required this.id,
    required this.courseworkId,
    required this.score,
    required this.maxScore,
    required this.approved,
    this.studentId,
    this.googleUserId,
  });

  final String id;
  final String courseworkId;
  final String? studentId;
  final String? googleUserId;
  final double score;
  final double maxScore;
  final bool approved;
}

class PublicationAttempt {
  const PublicationAttempt({
    required this.id,
    required this.gradingResultId,
    required this.publicationMode,
    required this.status,
    required this.attemptCount,
    required this.requestedGrade,
    this.externalSubmissionId,
    this.externalGradeBefore,
    this.externalGradeAfter,
    this.lastErrorCode,
    this.lastErrorMessage,
  });

  final String id;
  final String gradingResultId;
  final String? externalSubmissionId;
  final PublicationMode publicationMode;
  final PublicationAttemptStatus status;
  final int attemptCount;
  final double? externalGradeBefore;
  final double requestedGrade;
  final double? externalGradeAfter;
  final String? lastErrorCode;
  final String? lastErrorMessage;
}

class PublicationPreviewItem {
  const PublicationPreviewItem({
    required this.result,
    required this.eligible,
    this.blockedReason,
  });

  final GradingResult result;
  final bool eligible;
  final String? blockedReason;
}
