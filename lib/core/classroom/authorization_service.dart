class AuthorizationService {
  const AuthorizationService();

  bool sameTenant(Map<String, dynamic> user, String tenantId) {
    return user['tenantId'] == tenantId;
  }

  bool hasPermission(Map<String, dynamic> user, String permission) {
    return _permissions(user).contains(permission);
  }

  bool canManageIntegrations(Map<String, dynamic> user) {
    return hasPermission(user, 'manage_integrations');
  }

  bool canManageClass(
    Map<String, dynamic> user,
    Map<String, dynamic> schoolClass,
  ) {
    if (!sameTenant(user, schoolClass['tenantId'] as String)) {
      return false;
    }
    if (user['id'] == schoolClass['ownerTeacherId']) {
      return true;
    }
    return _assignedClassIds(user).contains(schoolClass['id']);
  }

  bool canApproveGrades(
    Map<String, dynamic> user,
    Map<String, dynamic> schoolClass, {
    String? subject,
  }) {
    return _canActOnClass(
          user,
          schoolClass,
          subject: subject,
        ) &&
        hasPermission(user, 'approve_grades');
  }

  bool canPublishGrades(
    Map<String, dynamic> user,
    Map<String, dynamic> schoolClass, {
    String? subject,
  }) {
    return _canActOnClass(
          user,
          schoolClass,
          subject: subject,
        ) &&
        hasPermission(user, 'publish_grades');
  }

  bool _canActOnClass(
    Map<String, dynamic> user,
    Map<String, dynamic> schoolClass, {
    String? subject,
  }) {
    if (!canManageClass(user, schoolClass)) {
      return false;
    }
    if (user['role'] == 'assistant') {
      final assignedSubject = user['assignedSubject'] as String?;
      if (assignedSubject != null &&
          subject != null &&
          assignedSubject != subject) {
        return false;
      }
    }
    return true;
  }

  List<String> _permissions(Map<String, dynamic> user) {
    final raw = user['permissions'];
    if (raw is List) {
      return raw.map((item) => '$item').toList();
    }
    return const [];
  }

  List<String> _assignedClassIds(Map<String, dynamic> user) {
    final raw = user['assignedClassIds'];
    if (raw is List) {
      return raw.map((item) => '$item').toList();
    }
    return const [];
  }
}
