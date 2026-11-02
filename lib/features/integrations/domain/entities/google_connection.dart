import '../../../../core/classroom/enums.dart';

class GoogleConnection {
  const GoogleConnection({
    required this.id,
    required this.tenantId,
    required this.ownerTeacherId,
    required this.status,
    required this.gradeSyncPolicy,
    required this.capabilityState,
    this.checkedAt,
    this.lastErrorMessage,
  });

  final String id;
  final String tenantId;
  final String ownerTeacherId;
  final ConnectionStatus status;
  final ConnectionGradeSyncPolicy gradeSyncPolicy;
  final CapabilityState capabilityState;
  final DateTime? checkedAt;
  final String? lastErrorMessage;

  bool get isConnected => status == ConnectionStatus.connected;
}

class ExternalCourseOption {
  const ExternalCourseOption({
    required this.id,
    required this.name,
    required this.section,
    required this.room,
    this.subject,
    this.createdByThisProject = true,
  });

  final String id;
  final String name;
  final String section;
  final String room;
  final String? subject;
  final bool createdByThisProject;
}
