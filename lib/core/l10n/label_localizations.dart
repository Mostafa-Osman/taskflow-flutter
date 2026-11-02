import '../../features/tasks/domain/entities/task_priority.dart';
import '../../features/tasks/domain/entities/task_status.dart';
import '../../l10n/app_localizations.dart';
import '../classroom/enums.dart';

extension TaskStatusL10n on TaskStatus {
  String l10n(AppLocalizations t) {
    return switch (this) {
      TaskStatus.todo => t.taskStatusTodo,
      TaskStatus.inProgress => t.taskStatusInProgress,
      TaskStatus.done => t.taskStatusDone,
    };
  }
}

extension TaskPriorityL10n on TaskPriority {
  String l10n(AppLocalizations t) {
    return switch (this) {
      TaskPriority.low => t.priorityLow,
      TaskPriority.medium => t.priorityMedium,
      TaskPriority.high => t.priorityHigh,
    };
  }
}

extension CourseworkPolicyL10n on CourseworkGradeSyncPolicy {
  String l10n(AppLocalizations t) {
    return switch (this) {
      CourseworkGradeSyncPolicy.inheritConnectionDefault => t.inheritPolicy,
      CourseworkGradeSyncPolicy.disabled => t.disablePublication,
      CourseworkGradeSyncPolicy.manualOnly => t.manualPublication,
      CourseworkGradeSyncPolicy.afterTeacherApproval => t.publishAfterApproval,
    };
  }
}

extension ConnectionPolicyL10n on ConnectionGradeSyncPolicy {
  String l10n(AppLocalizations t) {
    return switch (this) {
      ConnectionGradeSyncPolicy.disabled => t.policyDisabled,
      ConnectionGradeSyncPolicy.manualOnly => t.policyManualOnly,
      ConnectionGradeSyncPolicy.afterTeacherApproval => t.policyAfterApproval,
    };
  }
}
