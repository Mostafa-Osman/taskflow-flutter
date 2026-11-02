import '../../../../core/classroom/enums.dart';

class ClassFilter {
  const ClassFilter({
    this.sourceType,
    this.status,
    this.subject,
    this.teacherId,
    this.organizationId,
    this.connectedOnly = false,
    this.syncIssuesOnly = false,
  });

  final ClassSourceType? sourceType;
  final ClassStatus? status;
  final String? subject;
  final String? teacherId;
  final String? organizationId;
  final bool connectedOnly;
  final bool syncIssuesOnly;

  ClassFilter copyWith({
    ClassSourceType? sourceType,
    ClassStatus? status,
    String? subject,
    String? teacherId,
    String? organizationId,
    bool? connectedOnly,
    bool? syncIssuesOnly,
    bool clearSource = false,
    bool clearStatus = false,
    bool clearSubject = false,
  }) {
    return ClassFilter(
      sourceType: clearSource ? null : sourceType ?? this.sourceType,
      status: clearStatus ? null : status ?? this.status,
      subject: clearSubject ? null : subject ?? this.subject,
      teacherId: teacherId ?? this.teacherId,
      organizationId: organizationId ?? this.organizationId,
      connectedOnly: connectedOnly ?? this.connectedOnly,
      syncIssuesOnly: syncIssuesOnly ?? this.syncIssuesOnly,
    );
  }
}

class CreateClassInput {
  const CreateClassInput({
    required this.name,
    this.subject,
    this.description = '',
    this.organizationId,
  });

  final String name;
  final String? subject;
  final String description;
  final String? organizationId;
}
