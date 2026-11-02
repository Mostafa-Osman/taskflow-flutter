import '../../../../core/classroom/enums.dart';
import 'external_course_mapping.dart';

class SchoolClass {
  const SchoolClass({
    required this.id,
    required this.tenantId,
    required this.ownerTeacherId,
    required this.name,
    required this.sourceType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.connected,
    required this.hasSyncIssue,
    this.organizationId,
    this.subject,
    this.description = '',
    this.localNameOverride,
    this.mapping,
    this.externalSnapshot,
  });

  final String id;
  final String tenantId;
  final String ownerTeacherId;
  final String? organizationId;
  final String name;
  final String? localNameOverride;
  final String description;
  final ClassSourceType sourceType;
  final ClassStatus status;
  final String? subject;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool connected;
  final bool hasSyncIssue;
  final ExternalCourseMapping? mapping;
  final Map<String, dynamic>? externalSnapshot;

  String get displayName => localNameOverride?.isNotEmpty == true
      ? localNameOverride!
      : name;

  bool get isNative => sourceType == ClassSourceType.native;
}
