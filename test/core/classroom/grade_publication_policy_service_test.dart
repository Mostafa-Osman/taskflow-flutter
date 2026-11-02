import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/core/classroom/enums.dart';
import 'package:taskflow/core/classroom/grade_publication_policy_service.dart';

void main() {
  const service = GradePublicationPolicyService();

  test('connection disabled wins over every coursework policy', () {
    for (final coursework in CourseworkGradeSyncPolicy.values) {
      expect(
        service.resolve(
          connection: ConnectionGradeSyncPolicy.disabled,
          coursework: coursework,
        ),
        EffectiveGradeSyncPolicy.disabled,
      );
    }
  });

  test('coursework disabled wins when connection is enabled', () {
    expect(
      service.resolve(
        connection: ConnectionGradeSyncPolicy.manualOnly,
        coursework: CourseworkGradeSyncPolicy.disabled,
      ),
      EffectiveGradeSyncPolicy.disabled,
    );
  });

  test('coursework can inherit the connection policy', () {
    expect(
      service.resolve(
        connection: ConnectionGradeSyncPolicy.afterTeacherApproval,
        coursework: CourseworkGradeSyncPolicy.inheritConnectionDefault,
      ),
      EffectiveGradeSyncPolicy.afterTeacherApproval,
    );
  });

  test('missing permission keeps publication unavailable', () {
    expect(
      service.publicationAvailable(
        policy: EffectiveGradeSyncPolicy.manualOnly,
        hasPublishPermission: false,
      ),
      isFalse,
    );
    expect(
      service.canCreateAfterApprovalJob(
        policy: EffectiveGradeSyncPolicy.afterTeacherApproval,
        hasPublishPermission: false,
      ),
      isFalse,
    );
  });
}
