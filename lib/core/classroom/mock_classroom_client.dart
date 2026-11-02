import 'classroom_client.dart';
import 'enums.dart';

class MockClassroomClient implements ClassroomClient {
  MockClassroomClient() {
    resetFixtures();
  }

  final List<ExternalCourse> courses = [];
  final Map<String, List<ExternalStudent>> studentsByCourse = {};
  final Map<String, List<ExternalCoursework>> courseworkByCourse = {};
  final Map<String, ExternalSubmission> submissions = {};
  final Map<String, CapabilityState> courseworkCapabilities = {};

  bool nextPublishTimesOut = false;
  bool applyGradeOnTimeout = true;
  bool nextPublishDenied = false;
  bool connectionExpired = false;
  bool temporarilyUnavailable = false;

  void resetFixtures() {
    courses
      ..clear()
      ..addAll(const [
        ExternalCourse(
          id: 'gc-math-101',
          name: 'Algebra I',
          section: 'A',
          room: '204',
          createdByThisProject: true,
          subject: 'Math',
        ),
        ExternalCourse(
          id: 'gc-hist-201',
          name: 'World History',
          section: 'B',
          room: '118',
          createdByThisProject: false,
          subject: 'History',
        ),
        ExternalCourse(
          id: 'gc-sci-301',
          name: 'Biology',
          section: 'C',
          room: '312',
          createdByThisProject: true,
          subject: 'Science',
        ),
      ]);
    studentsByCourse
      ..clear()
      ..addAll({
        'gc-math-101': const [
          ExternalStudent(
            googleUserId: 'g-stu-1',
            email: 'sam@school.edu',
            displayName: 'Sam Rivera',
          ),
          ExternalStudent(
            googleUserId: 'g-stu-2',
            email: 'lee@school.edu',
            displayName: 'Lee Park',
          ),
        ],
        'gc-hist-201': const [
          ExternalStudent(
            googleUserId: 'g-stu-3',
            email: 'ava@school.edu',
            displayName: 'Ava Chen',
          ),
        ],
        'gc-sci-301': const [
          ExternalStudent(
            googleUserId: 'g-stu-4',
            email: 'jordan@school.edu',
            displayName: 'Jordan Blake',
          ),
        ],
      });
    courseworkByCourse
      ..clear()
      ..addAll({
        'gc-math-101': const [
          ExternalCoursework(
            id: 'cw-math-quiz',
            courseId: 'gc-math-101',
            title: 'Quiz 1',
            maxPoints: 100,
            createdByThisProject: true,
          ),
        ],
        'gc-hist-201': const [
          ExternalCoursework(
            id: 'cw-hist-essay',
            courseId: 'gc-hist-201',
            title: 'Essay',
            maxPoints: 50,
            createdByThisProject: false,
          ),
        ],
        'gc-sci-301': const [
          ExternalCoursework(
            id: 'cw-sci-lab',
            courseId: 'gc-sci-301',
            title: 'Lab report',
            maxPoints: 80,
            createdByThisProject: true,
          ),
        ],
      });
    submissions
      ..clear()
      ..addAll({
        _key('cw-math-quiz', 'g-stu-1'): const ExternalSubmission(
          id: 'sub-math-1',
          courseworkId: 'cw-math-quiz',
          googleUserId: 'g-stu-1',
        ),
        _key('cw-math-quiz', 'g-stu-2'): const ExternalSubmission(
          id: 'sub-math-2',
          courseworkId: 'cw-math-quiz',
          googleUserId: 'g-stu-2',
        ),
        _key('cw-hist-essay', 'g-stu-3'): const ExternalSubmission(
          id: 'sub-hist-3',
          courseworkId: 'cw-hist-essay',
          googleUserId: 'g-stu-3',
        ),
        _key('cw-sci-lab', 'g-stu-4'): const ExternalSubmission(
          id: 'sub-sci-4',
          courseworkId: 'cw-sci-lab',
          googleUserId: 'g-stu-4',
        ),
      });
    courseworkCapabilities
      ..clear()
      ..addAll({
        'cw-math-quiz': CapabilityState.supported,
        'cw-hist-essay': CapabilityState.unsupported,
        'cw-sci-lab': CapabilityState.supported,
      });
    nextPublishTimesOut = false;
    applyGradeOnTimeout = true;
    nextPublishDenied = false;
    connectionExpired = false;
    temporarilyUnavailable = false;
  }

  void setExternalGrade({
    required String courseworkId,
    required String googleUserId,
    required double grade,
  }) {
    final key = _key(courseworkId, googleUserId);
    final current = submissions[key];
    if (current == null) {
      submissions[key] = ExternalSubmission(
        id: 'sub-$courseworkId-$googleUserId',
        courseworkId: courseworkId,
        googleUserId: googleUserId,
        assignedGrade: grade,
      );
      return;
    }
    submissions[key] = ExternalSubmission(
      id: current.id,
      courseworkId: current.courseworkId,
      googleUserId: current.googleUserId,
      assignedGrade: grade,
      draftGrade: current.draftGrade,
    );
  }

  @override
  Future<List<ExternalCourse>> listCourses({required String connectionId}) {
    _throwIfConnectionBlocked();
    return Future.value(List<ExternalCourse>.from(courses));
  }

  @override
  Future<List<ExternalStudent>> listStudents({required String courseId}) {
    _throwIfConnectionBlocked();
    return Future.value(
      List<ExternalStudent>.from(studentsByCourse[courseId] ?? const []),
    );
  }

  @override
  Future<List<ExternalCoursework>> listCoursework({required String courseId}) {
    _throwIfConnectionBlocked();
    return Future.value(
      List<ExternalCoursework>.from(courseworkByCourse[courseId] ?? const []),
    );
  }

  @override
  Future<CapabilityState> checkGradePublicationCapability({
    required String connectionId,
    required String courseworkId,
  }) {
    if (connectionExpired) {
      return Future.value(CapabilityState.requiresReauthorization);
    }
    if (temporarilyUnavailable) {
      return Future.value(CapabilityState.temporarilyUnavailable);
    }
    return Future.value(
      courseworkCapabilities[courseworkId] ?? CapabilityState.unknown,
    );
  }

  @override
  Future<ExternalSubmission> getSubmission({
    required String courseworkId,
    required String googleUserId,
  }) {
    _throwIfConnectionBlocked();
    final submission = submissions[_key(courseworkId, googleUserId)];
    if (submission == null) {
      throw const ClassroomClientException(
        code: 'SUBMISSION_NOT_FOUND',
        message: 'External submission is unavailable.',
      );
    }
    return Future.value(submission);
  }

  @override
  Future<ExternalGradeWriteResult> publishGrade({
    required String courseworkId,
    required String googleUserId,
    required double score,
  }) async {
    _throwIfConnectionBlocked();
    if (nextPublishDenied) {
      nextPublishDenied = false;
      throw const ClassroomClientException(
        code: 'PERMISSION_DENIED',
        message: 'Missing Classroom grade permission.',
        capability: CapabilityState.permissionDenied,
      );
    }
    final key = _key(courseworkId, googleUserId);
    if (nextPublishTimesOut) {
      nextPublishTimesOut = false;
      if (applyGradeOnTimeout) {
        setExternalGrade(
          courseworkId: courseworkId,
          googleUserId: googleUserId,
          grade: score,
        );
      }
      throw const ClassroomClientException(
        code: 'TIMEOUT',
        message: 'Classroom API timed out.',
        capability: CapabilityState.temporarilyUnavailable,
      );
    }
    final current = submissions[key];
    if (current == null) {
      throw const ClassroomClientException(
        code: 'SUBMISSION_NOT_FOUND',
        message: 'External submission is unavailable.',
      );
    }
    setExternalGrade(
      courseworkId: courseworkId,
      googleUserId: googleUserId,
      grade: score,
    );
    return ExternalGradeWriteResult(
      submissionId: current.id,
      assignedGrade: score,
    );
  }

  void _throwIfConnectionBlocked() {
    if (connectionExpired) {
      throw const ClassroomClientException(
        code: 'EXPIRED',
        message: 'Google Classroom connection requires reauthorization.',
        capability: CapabilityState.requiresReauthorization,
      );
    }
    if (temporarilyUnavailable) {
      throw const ClassroomClientException(
        code: 'UNAVAILABLE',
        message: 'Google Classroom is temporarily unavailable.',
        capability: CapabilityState.temporarilyUnavailable,
      );
    }
  }

  String _key(String courseworkId, String googleUserId) {
    return '$courseworkId|$googleUserId';
  }
}
