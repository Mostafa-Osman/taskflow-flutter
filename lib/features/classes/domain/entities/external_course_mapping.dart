import '../../../../core/classroom/enums.dart';

class ExternalCourseMapping {
  const ExternalCourseMapping({
    required this.id,
    required this.tenantId,
    required this.internalClassId,
    required this.externalConnectionId,
    required this.provider,
    required this.externalCourseId,
    required this.mappingStatus,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String tenantId;
  final String internalClassId;
  final String externalConnectionId;
  final String provider;
  final String externalCourseId;
  final MappingStatus mappingStatus;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
}
