import 'enums.dart';

class GradePublicationPolicyService {
  const GradePublicationPolicyService();

  EffectiveGradeSyncPolicy resolve({
    required ConnectionGradeSyncPolicy connection,
    required CourseworkGradeSyncPolicy coursework,
  }) {
    if (connection == ConnectionGradeSyncPolicy.disabled) {
      return EffectiveGradeSyncPolicy.disabled;
    }
    if (coursework == CourseworkGradeSyncPolicy.disabled) {
      return EffectiveGradeSyncPolicy.disabled;
    }
    if (coursework == CourseworkGradeSyncPolicy.inheritConnectionDefault) {
      return switch (connection) {
        ConnectionGradeSyncPolicy.manualOnly =>
          EffectiveGradeSyncPolicy.manualOnly,
        ConnectionGradeSyncPolicy.afterTeacherApproval =>
          EffectiveGradeSyncPolicy.afterTeacherApproval,
        ConnectionGradeSyncPolicy.disabled => EffectiveGradeSyncPolicy.disabled,
      };
    }
    return switch (coursework) {
      CourseworkGradeSyncPolicy.manualOnly =>
        EffectiveGradeSyncPolicy.manualOnly,
      CourseworkGradeSyncPolicy.afterTeacherApproval =>
        EffectiveGradeSyncPolicy.afterTeacherApproval,
      CourseworkGradeSyncPolicy.inheritConnectionDefault ||
      CourseworkGradeSyncPolicy.disabled => EffectiveGradeSyncPolicy.disabled,
    };
  }

  bool publicationAvailable({
    required EffectiveGradeSyncPolicy policy,
    required bool hasPublishPermission,
  }) {
    return hasPublishPermission && policy != EffectiveGradeSyncPolicy.disabled;
  }

  bool canCreateAfterApprovalJob({
    required EffectiveGradeSyncPolicy policy,
    required bool hasPublishPermission,
  }) {
    return hasPublishPermission &&
        policy == EffectiveGradeSyncPolicy.afterTeacherApproval;
  }

  bool canManuallyPublish({
    required EffectiveGradeSyncPolicy policy,
    required bool hasPublishPermission,
  }) {
    return publicationAvailable(
      policy: policy,
      hasPublishPermission: hasPublishPermission,
    );
  }
}
