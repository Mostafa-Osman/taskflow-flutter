import 'enums.dart';

class MappingValidation {
  const MappingValidation.ok() : error = null;
  const MappingValidation.error(this.error);

  final String? error;

  bool get isValid => error == null;
}

class ImportOutcome {
  const ImportOutcome({
    required this.schoolClass,
    required this.mapping,
    required this.alreadyExisted,
  });

  final Map<String, dynamic> schoolClass;
  final Map<String, dynamic> mapping;
  final bool alreadyExisted;
}

class RosterLink {
  const RosterLink({
    required this.student,
    required this.status,
  });

  final Map<String, dynamic> student;
  final RosterLinkStatus status;
}

class ClassMappingService {
  const ClassMappingService();

  MappingValidation validateMap({
    required Map<String, dynamic> user,
    required Map<String, dynamic> schoolClass,
    required Map<String, dynamic> connection,
    required String externalCourseId,
    required bool courseVisible,
    required bool confirmed,
    required List<Map<String, dynamic>> mappings,
  }) {
    if (user['tenantId'] != schoolClass['tenantId']) {
      return const MappingValidation.error('Class belongs to another tenant.');
    }
    if (user['tenantId'] != connection['tenantId']) {
      return const MappingValidation.error(
        'Connection belongs to another tenant.',
      );
    }
    final owns =
        user['id'] == schoolClass['ownerTeacherId'] ||
        (user['assignedClassIds'] as List<dynamic>? ?? const []).contains(
          schoolClass['id'],
        );
    if (!owns) {
      return const MappingValidation.error(
        'You are not assigned to this class.',
      );
    }
    if (connection['status'] != ConnectionStatus.connected.apiValue) {
      return const MappingValidation.error(
        'Google Classroom is not connected.',
      );
    }
    if (!courseVisible) {
      return const MappingValidation.error(
        'The Google course is not visible on this connection.',
      );
    }
    if (!confirmed) {
      return const MappingValidation.error(
        'Mapping must be explicitly confirmed.',
      );
    }
    final classMapped = mappings.any(
      (mapping) =>
          mapping['internalClassId'] == schoolClass['id'] &&
          mapping['mappingStatus'] == MappingStatus.active.apiValue,
    );
    if (classMapped) {
      return const MappingValidation.error(
        'This class already has an active Google mapping.',
      );
    }
    final courseMapped = mappings.any(
      (mapping) =>
          mapping['tenantId'] == user['tenantId'] &&
          mapping['externalConnectionId'] == connection['id'] &&
          mapping['externalCourseId'] == externalCourseId &&
          mapping['mappingStatus'] == MappingStatus.active.apiValue,
    );
    if (courseMapped) {
      return const MappingValidation.error(
        'This Google course is already mapped in this connection.',
      );
    }
    return const MappingValidation.ok();
  }

  ImportOutcome importCourse({
    required Map<String, dynamic> user,
    required Map<String, dynamic> connection,
    required Map<String, dynamic> course,
    required List<Map<String, dynamic>> classes,
    required List<Map<String, dynamic>> mappings,
    required String now,
    required String Function(String prefix) nextId,
  }) {
    final existing = mappings.cast<Map<String, dynamic>?>().firstWhere((
      mapping,
    ) {
      return mapping!['tenantId'] == user['tenantId'] &&
          mapping['externalConnectionId'] == connection['id'] &&
          mapping['externalCourseId'] == course['id'] &&
          mapping['mappingStatus'] == MappingStatus.active.apiValue;
    }, orElse: () => null);

    if (existing != null) {
      final schoolClass = classes.firstWhere(
        (item) => item['id'] == existing['internalClassId'],
      );
      return ImportOutcome(
        schoolClass: schoolClass,
        mapping: existing,
        alreadyExisted: true,
      );
    }

    final classId = nextId('cls');
    final schoolClass = <String, dynamic>{
      'id': classId,
      'tenantId': user['tenantId'],
      'ownerTeacherId': user['id'],
      'organizationId': user['organizationId'],
      'name': course['name'],
      'localNameOverride': null,
      'description': '',
      'sourceType': ClassSourceType.externalImport.apiValue,
      'status': ClassStatus.active.apiValue,
      'subject': course['subject'],
      'createdAt': now,
      'updatedAt': now,
    };
    final mapping = <String, dynamic>{
      'id': nextId('map'),
      'tenantId': user['tenantId'],
      'internalClassId': classId,
      'externalConnectionId': connection['id'],
      'provider': 'GOOGLE_CLASSROOM',
      'externalCourseId': course['id'],
      'mappingStatus': MappingStatus.active.apiValue,
      'createdBy': user['id'],
      'createdAt': now,
      'updatedAt': now,
    };
    return ImportOutcome(
      schoolClass: schoolClass,
      mapping: mapping,
      alreadyExisted: false,
    );
  }

  RosterLink linkStudent({
    required Map<String, dynamic> incoming,
    required List<Map<String, dynamic>> existingStudents,
    required String tenantId,
    required String classId,
    required String now,
    required String Function(String prefix) nextId,
  }) {
    final googleUserId = incoming['googleUserId'] as String?;
    if (googleUserId != null && googleUserId.isNotEmpty) {
      final byGoogle = existingStudents.cast<Map<String, dynamic>?>().firstWhere(
        (student) => student!['googleUserId'] == googleUserId,
        orElse: () => null,
      );
      if (byGoogle != null) {
        return RosterLink(
          student: byGoogle,
          status: RosterLinkStatus.linkedByGoogleId,
        );
      }
    }

    final email = (incoming['email'] as String? ?? '').trim().toLowerCase();
    final verified = incoming['verifiedEmail'] == true;
    if (verified && email.isNotEmpty) {
      final byEmail = existingStudents.cast<Map<String, dynamic>?>().firstWhere(
        (student) {
          final candidate =
              (student!['email'] as String? ?? '').trim().toLowerCase();
          return candidate == email && student['emailVerified'] == true;
        },
        orElse: () => null,
      );
      if (byEmail != null) {
        return RosterLink(
          student: byEmail,
          status: RosterLinkStatus.linkedByEmail,
        );
      }
    }

    final student = <String, dynamic>{
      'id': nextId('stu'),
      'tenantId': tenantId,
      'classId': classId,
      'displayName': incoming['displayName'],
      'email': email,
      'emailVerified': verified,
      'phone': incoming['phone'],
      'googleUserId': googleUserId,
      'linkStatus': RosterLinkStatus.unmatched.apiValue,
      'createdAt': now,
      'updatedAt': now,
    };
    return RosterLink(student: student, status: RosterLinkStatus.unmatched);
  }
}
