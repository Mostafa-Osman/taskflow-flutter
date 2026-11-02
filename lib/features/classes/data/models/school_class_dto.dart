import '../../../../core/classroom/enums.dart';
import '../../domain/entities/external_course_mapping.dart';
import '../../domain/entities/school_class.dart';

class SchoolClassDto {
  const SchoolClassDto({
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
  final String sourceType;
  final String status;
  final String? subject;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool connected;
  final bool hasSyncIssue;
  final Map<String, dynamic>? mapping;
  final Map<String, dynamic>? externalSnapshot;

  factory SchoolClassDto.fromJson(Map<String, dynamic> json) {
    return SchoolClassDto(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      ownerTeacherId: json['ownerTeacherId'] as String,
      organizationId: json['organizationId'] as String?,
      name: json['name'] as String,
      localNameOverride: json['localNameOverride'] as String?,
      description: json['description'] as String? ?? '',
      sourceType: json['sourceType'] as String,
      status: json['status'] as String,
      subject: json['subject'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      connected: json['connected'] == true,
      hasSyncIssue: json['hasSyncIssue'] == true,
      mapping: json['mapping'] as Map<String, dynamic>?,
      externalSnapshot: json['externalSnapshot'] as Map<String, dynamic>?,
    );
  }

  SchoolClass toEntity() {
    return SchoolClass(
      id: id,
      tenantId: tenantId,
      ownerTeacherId: ownerTeacherId,
      organizationId: organizationId,
      name: name,
      localNameOverride: localNameOverride,
      description: description,
      sourceType: ClassSourceType.fromApi(sourceType),
      status: ClassStatus.fromApi(status),
      subject: subject,
      createdAt: createdAt,
      updatedAt: updatedAt,
      connected: connected,
      hasSyncIssue: hasSyncIssue,
      mapping: mapping == null ? null : _mappingFromJson(mapping!),
      externalSnapshot: externalSnapshot,
    );
  }

  ExternalCourseMapping _mappingFromJson(Map<String, dynamic> json) {
    return ExternalCourseMapping(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      internalClassId: json['internalClassId'] as String,
      externalConnectionId: json['externalConnectionId'] as String,
      provider: json['provider'] as String,
      externalCourseId: json['externalCourseId'] as String,
      mappingStatus: MappingStatus.fromApi(json['mappingStatus'] as String?),
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
