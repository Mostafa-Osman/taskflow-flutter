import 'user_role.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.tenantId = 'tenant-a',
    this.role = UserRole.teacher,
    this.organizationId,
    this.assignedClassIds = const [],
    this.assignedSubject,
    this.permissions = const [],
  });

  final String id;
  final String name;
  final String email;
  final String tenantId;
  final UserRole role;
  final String? organizationId;
  final List<String> assignedClassIds;
  final String? assignedSubject;
  final List<String> permissions;

  bool get canPublishGrades => permissions.contains('publish_grades');

  bool get canApproveGrades => permissions.contains('approve_grades');

  bool get canManageIntegrations => permissions.contains('manage_integrations');
}
