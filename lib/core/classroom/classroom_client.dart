import 'enums.dart';

class ExternalCourse {
  const ExternalCourse({
    required this.id,
    required this.name,
    required this.section,
    required this.room,
    required this.createdByThisProject,
    this.subject,
  });

  final String id;
  final String name;
  final String section;
  final String room;
  final bool createdByThisProject;
  final String? subject;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'section': section,
    'room': room,
    'createdByThisProject': createdByThisProject,
    'subject': subject,
  };
}

class ExternalStudent {
  const ExternalStudent({
    required this.googleUserId,
    required this.email,
    required this.displayName,
    this.phone,
    this.verifiedEmail = true,
  });

  final String googleUserId;
  final String email;
  final String displayName;
  final String? phone;
  final bool verifiedEmail;
}

class ExternalCoursework {
  const ExternalCoursework({
    required this.id,
    required this.courseId,
    required this.title,
    required this.maxPoints,
    required this.createdByThisProject,
  });

  final String id;
  final String courseId;
  final String title;
  final double maxPoints;
  final bool createdByThisProject;
}

class ExternalSubmission {
  const ExternalSubmission({
    required this.id,
    required this.courseworkId,
    required this.googleUserId,
    this.assignedGrade,
    this.draftGrade,
  });

  final String id;
  final String courseworkId;
  final String googleUserId;
  final double? assignedGrade;
  final double? draftGrade;
}

class ExternalGradeWriteResult {
  const ExternalGradeWriteResult({
    required this.submissionId,
    required this.assignedGrade,
  });

  final String submissionId;
  final double assignedGrade;
}

class ClassroomClientException implements Exception {
  const ClassroomClientException({
    required this.code,
    required this.message,
    this.capability = CapabilityState.temporarilyUnavailable,
  });

  final String code;
  final String message;
  final CapabilityState capability;

  @override
  String toString() => message;
}

abstract class ClassroomClient {
  Future<List<ExternalCourse>> listCourses({required String connectionId});

  Future<List<ExternalStudent>> listStudents({required String courseId});

  Future<List<ExternalCoursework>> listCoursework({required String courseId});

  Future<CapabilityState> checkGradePublicationCapability({
    required String connectionId,
    required String courseworkId,
  });

  Future<ExternalSubmission> getSubmission({
    required String courseworkId,
    required String googleUserId,
  });

  Future<ExternalGradeWriteResult> publishGrade({
    required String courseworkId,
    required String googleUserId,
    required double score,
  });
}
