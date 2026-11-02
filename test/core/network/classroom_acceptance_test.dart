import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/core/classroom/enums.dart';
import 'package:taskflow/core/classroom/mock_classroom_client.dart';
import 'package:taskflow/core/network/mock_backend_store.dart';
import 'package:taskflow/core/storage/local_preferences.dart';

class MemoryPreferences implements LocalPreferences {
  final Map<String, String> values = {};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> remove(String key) async => values.remove(key);

  @override
  Future<void> setString(String key, String value) async => values[key] = value;
}

void main() {
  late MockBackendStore store;
  late MockClassroomClient classroom;

  setUp(() async {
    store = MockBackendStore(preferences: MemoryPreferences());
    classroom = store.classroom.classroomClient as MockClassroomClient;
    await store.initialize();
  });

  Future<String> login(String email) async {
    final response = await store.handle(
      RequestOptions(
        path: '/auth/login',
        method: 'POST',
        data: {'email': email, 'password': 'password123'},
      ),
    );
    return (response.data as Map<String, dynamic>)['token'] as String;
  }

  RequestOptions req(
    String token, {
    required String path,
    String method = 'GET',
    Object? data,
    Map<String, dynamic>? query,
  }) {
    return RequestOptions(
      path: path,
      method: method,
      data: data,
      queryParameters: query,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Map<String, dynamic>> createNative(String token, String name) async {
    final response = await store.handle(
      req(
        token,
        path: '/classes',
        method: 'POST',
        data: {'name': name, 'subject': 'Math'},
      ),
    );
    return response.data as Map<String, dynamic>;
  }

  test('1. teacher can create Native classes without Google Classroom', () async {
    final token = await login('jane@taskflow.dev');
    final created = await createNative(token, 'Homeroom');
    expect(created['sourceType'], 'NATIVE');
    expect(created['connected'], isFalse);
    expect(store.classroom.connections, isEmpty);

    final listed = await store.handle(req(token, path: '/classes'));
    final items = listed.data as List<dynamic>;
    expect(items, hasLength(1));
    expect((items.first as Map<String, dynamic>)['name'], 'Homeroom');
  });

  test('2. same teacher can create Native classes and import Google courses', () async {
    final token = await login('jane@taskflow.dev');
    await createNative(token, 'Homeroom');
    await store.handle(
      req(token, path: '/integrations/google-classroom/connect', method: 'POST'),
    );
    final imported = await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/courses/import',
        method: 'POST',
        data: {
          'courseIds': ['gc-math-101'],
        },
      ),
    );
    expect(imported.statusCode, 201);
    final listed = await store.handle(req(token, path: '/classes'));
    final items = (listed.data as List<dynamic>).cast<Map<String, dynamic>>();
    expect(items.any((item) => item['sourceType'] == 'NATIVE'), isTrue);
    expect(items.any((item) => item['sourceType'] == 'EXTERNAL_IMPORT'), isTrue);
  });

  test('3. repeated imports do not create duplicate classes or mappings', () async {
    final token = await login('jane@taskflow.dev');
    await store.handle(
      req(token, path: '/integrations/google-classroom/connect', method: 'POST'),
    );
    Future<List<Map<String, dynamic>>> importOnce() async {
      final response = await store.handle(
        req(
          token,
          path: '/integrations/google-classroom/courses/import',
          method: 'POST',
          data: {
            'courseIds': ['gc-math-101'],
          },
        ),
      );
      return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
    }

    final first = await importOnce();
    final second = await importOnce();
    expect(first.single['id'], second.single['id']);
    expect(store.classroom.classes, hasLength(1));
    expect(
      store.classroom.mappings
          .where((item) => item['mappingStatus'] == 'ACTIVE')
          .length,
      1,
    );
  });

  test('4. unmapping preserves the internal class and historical data', () async {
    final token = await login('jane@taskflow.dev');
    await store.handle(
      req(token, path: '/integrations/google-classroom/connect', method: 'POST'),
    );
    final imported = await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/courses/import',
        method: 'POST',
        data: {
          'courseIds': ['gc-math-101'],
        },
      ),
    );
    final schoolClass =
        (imported.data as List<dynamic>).first as Map<String, dynamic>;
    final coursework = store.classroom.coursework.first;
    await store.handle(
      req(
        token,
        path: '/coursework/${coursework['id']}/results',
        method: 'POST',
        data: {'studentId': 'stu-local', 'googleUserId': 'g-stu-1', 'score': 88},
      ),
    );
    final mappingId = schoolClass['mapping']['id'] as String;
    final unmapped = await store.handle(
      req(
        token,
        path: '/classes/${schoolClass['id']}/mappings/$mappingId',
        method: 'DELETE',
      ),
    );
    expect(unmapped.statusCode, 200);
    expect(
      (unmapped.data as Map<String, dynamic>)['preservedResultCount'],
      1,
    );
    expect(store.classroom.classes, hasLength(1));
    expect(store.classroom.classes.first['name'], 'Algebra I');
    expect(
      store.classroom.mappings.single['mappingStatus'],
      MappingStatus.unmapped.apiValue,
    );
  });

  test('5. disconnecting Google Classroom does not delete Native data', () async {
    final token = await login('jane@taskflow.dev');
    await createNative(token, 'Homeroom');
    await store.handle(
      req(token, path: '/integrations/google-classroom/connect', method: 'POST'),
    );
    await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/courses/import',
        method: 'POST',
        data: {
          'courseIds': ['gc-math-101'],
        },
      ),
    );
    final disconnected = await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/disconnect',
        method: 'POST',
      ),
    );
    expect(disconnected.statusCode, 200);
    expect(store.classroom.classes, hasLength(2));
    expect(
      store.classroom.connections.single['status'],
      ConnectionStatus.disconnected.apiValue,
    );
    expect(
      (disconnected.data as Map<String, dynamic>)['preservedClassIds'],
      hasLength(2),
    );
  });

  test('6. connection-level disabled policy prevents all publication', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _readyCoursework(store, token);
    final result = await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (result.data as Map<String, dynamic>)['id'] as String;
    await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final published = await store.handle(
      req(
        token,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    expect(published.statusCode, 400);
    expect(store.classroom.publicationAttempts, isEmpty);
  });

  test('7. coursework disabled blocks publication even if connection allows it', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _readyCoursework(store, token);
    await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/settings',
        method: 'PATCH',
        data: {'gradeSyncPolicy': 'MANUAL_ONLY'},
      ),
    );
    await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/grade-policy',
        method: 'PATCH',
        data: {'gradeSyncPolicy': 'DISABLED'},
      ),
    );
    final created = await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final published = await store.handle(
      req(
        token,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    expect(published.statusCode, 400);
  });

  test('8. coursework can inherit the connection policy', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _readyCoursework(store, token);
    await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/settings',
        method: 'PATCH',
        data: {'gradeSyncPolicy': 'MANUAL_ONLY'},
      ),
    );
    final policy = await store.handle(
      req(token, path: '/coursework/${ready['id']}/grade-policy'),
    );
    expect(
      (policy.data as Map<String, dynamic>)['effectivePolicy'],
      'MANUAL_ONLY',
    );
  });

  test('9. manual publication works only for authorized eligible submissions', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _enableManual(store, token);
    final created = await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    final blocked = await store.handle(
      req(
        token,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    expect(blocked.statusCode, 400);
    await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final published = await store.handle(
      req(
        token,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    expect(published.statusCode, 200);
    expect(
      ((published.data as List<dynamic>).first as Map<String, dynamic>)['status'],
      'SUCCEEDED',
    );
  });

  test('10. after-approval creates a job only when policy permits it', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _readyCoursework(store, token);
    await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/settings',
        method: 'PATCH',
        data: {'gradeSyncPolicy': 'AFTER_TEACHER_APPROVAL'},
      ),
    );
    final created = await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    final approved = await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    expect(
      (approved.data as Map<String, dynamic>)['publicationAttempt'],
      isNotNull,
    );
    expect(store.classroom.publicationAttempts, hasLength(1));
  });

  test('11. approval alone does not publish when publication is disabled', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _readyCoursework(store, token);
    final created = await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    final approved = await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final payload = approved.data as Map<String, dynamic>;
    expect(payload['publicationAttempt'], isNull);
    expect(payload['published'], isFalse);
    expect((payload['result'] as Map<String, dynamic>)['approved'], isTrue);
    expect(store.classroom.publicationAttempts, isEmpty);
  });

  test('12. unsupported coursework cannot publish grades', () async {
    final token = await login('jane@taskflow.dev');
    await store.handle(
      req(token, path: '/integrations/google-classroom/connect', method: 'POST'),
    );
    await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/settings',
        method: 'PATCH',
        data: {'gradeSyncPolicy': 'MANUAL_ONLY'},
      ),
    );
    await store.handle(
      req(
        token,
        path: '/integrations/google-classroom/courses/import',
        method: 'POST',
        data: {
          'courseIds': ['gc-hist-201'],
        },
      ),
    );
    final item = store.classroom.coursework.single;
    expect(item['capabilityState'], 'UNSUPPORTED');
    final created = await store.handle(
      req(
        token,
        path: '/coursework/${item['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-3', 'score': 40},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final published = await store.handle(
      req(
        token,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    expect(published.statusCode, 400);
  });

  test('13. missing permissions block publication', () async {
    final jane = await login('jane@taskflow.dev');
    final ready = await _enableManual(store, jane);
    final created = await store.handle(
      req(
        jane,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    await store.handle(
      req(jane, path: '/grades/$resultId/approve', method: 'POST'),
    );
    store.classroom.assignUserToClass(
      user: store.findUserByEmail('alex@taskflow.dev')!,
      classId: ready['classId'] as String,
      subject: 'Math',
    );
    final assistant = await login('alex@taskflow.dev');
    final published = await store.handle(
      req(
        assistant,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    expect(published.statusCode, 403);
  });

  test('14. temporary failures are distinguishable from unsupported', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _readyCoursework(store, token);
    expect(ready['capabilityState'], 'SUPPORTED');
    classroom.temporarilyUnavailable = true;
    await store.classroom.refreshAllCapabilities();
    expect(
      store.classroom.coursework.single['capabilityState'],
      'TEMPORARILY_UNAVAILABLE',
    );
    expect(
      store.classroom.coursework.single['lastErrorMessage'],
      contains('temporarily unavailable'),
    );
  });

  test('15. expired connections require reauthorization', () async {
    final token = await login('jane@taskflow.dev');
    await store.handle(
      req(token, path: '/integrations/google-classroom/connect', method: 'POST'),
    );
    classroom.connectionExpired = true;
    final courses = await store.handle(
      req(token, path: '/integrations/google-classroom/courses'),
    );
    expect(courses.statusCode, 401);
    expect(
      store.classroom.connections.single['status'],
      ConnectionStatus.requiresReauthorization.apiValue,
    );
  });

  test('16. external grade conflicts are detected before overwrite', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _enableManual(store, token);
    classroom.setExternalGrade(
      courseworkId: 'cw-math-quiz',
      googleUserId: 'g-stu-1',
      grade: 70,
    );
    final created = await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final published = await store.handle(
      req(
        token,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    final attempt =
        (published.data as List<dynamic>).first as Map<String, dynamic>;
    expect(attempt['status'], 'CONFLICT');
    expect(classroom.submissions.values.first.assignedGrade, 70);
  });

  test('17. retry after timeout does not blindly overwrite an external grade', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _enableManual(store, token);
    classroom.nextPublishTimesOut = true;
    classroom.applyGradeOnTimeout = false;
    final created = await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final first = await store.handle(
      req(
        token,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    final attempt = (first.data as List<dynamic>).first as Map<String, dynamic>;
    expect(attempt['status'], 'FAILED');
    classroom.setExternalGrade(
      courseworkId: 'cw-math-quiz',
      googleUserId: 'g-stu-1',
      grade: 55,
    );
    final retry = await store.handle(
      req(
        token,
        path: '/grades/publications/${attempt['id']}/retry',
        method: 'POST',
      ),
    );
    expect((retry.data as Map<String, dynamic>)['status'], 'CONFLICT');
    expect(
      classroom.submissions.values
          .firstWhere((item) => item.googleUserId == 'g-stu-1')
          .assignedGrade,
      55,
    );
  });

  test('18. assistant cannot publish outside assigned class or permission', () async {
    final jane = await login('jane@taskflow.dev');
    final ready = await _enableManual(store, jane);
    final created = await store.handle(
      req(
        jane,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    await store.handle(
      req(jane, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final assistant = await login('alex@taskflow.dev');
    final published = await store.handle(
      req(
        assistant,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    expect(published.statusCode, 403);
  });

  test('19. another tenant cannot change settings or publish grades', () async {
    final jane = await login('jane@taskflow.dev');
    final ready = await _enableManual(store, jane);
    final other = await login('riley@other.dev');
    final settings = await store.handle(
      req(
        other,
        path: '/integrations/google-classroom/settings',
        method: 'PATCH',
        data: {'gradeSyncPolicy': 'MANUAL_ONLY'},
      ),
    );
    expect(settings.statusCode, 404);
    final created = await store.handle(
      req(
        jane,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    await store.handle(
      req(jane, path: '/grades/$resultId/approve', method: 'POST'),
    );
    final published = await store.handle(
      req(
        other,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    expect(published.statusCode, 403);
  });

  test('20. publication status is based on the API outcome', () async {
    final token = await login('jane@taskflow.dev');
    final ready = await _enableManual(store, token);
    final created = await store.handle(
      req(
        token,
        path: '/coursework/${ready['id']}/results',
        method: 'POST',
        data: {'googleUserId': 'g-stu-1', 'score': 91},
      ),
    );
    final resultId = (created.data as Map<String, dynamic>)['id'] as String;
    final approved = await store.handle(
      req(token, path: '/grades/$resultId/approve', method: 'POST'),
    );
    expect((approved.data as Map<String, dynamic>)['published'], isFalse);
    final published = await store.handle(
      req(
        token,
        path: '/grades/publications',
        method: 'POST',
        data: {
          'resultIds': [resultId],
        },
      ),
    );
    final attempt =
        (published.data as List<dynamic>).first as Map<String, dynamic>;
    expect(attempt['status'], 'SUCCEEDED');
    expect(attempt['externalGradeAfter'], 91);
  });
}

Future<Map<String, dynamic>> _readyCoursework(
  MockBackendStore store,
  String token,
) async {
  await store.handle(
    RequestOptions(
      path: '/integrations/google-classroom/connect',
      method: 'POST',
      headers: {'Authorization': 'Bearer $token'},
    ),
  );
  await store.handle(
    RequestOptions(
      path: '/integrations/google-classroom/courses/import',
      method: 'POST',
      headers: {'Authorization': 'Bearer $token'},
      data: {
        'courseIds': ['gc-math-101'],
      },
    ),
  );
  return store.classroom.coursework.single;
}

Future<Map<String, dynamic>> _enableManual(
  MockBackendStore store,
  String token,
) async {
  final ready = await _readyCoursework(store, token);
  await store.handle(
    RequestOptions(
      path: '/integrations/google-classroom/settings',
      method: 'PATCH',
      headers: {'Authorization': 'Bearer $token'},
      data: {'gradeSyncPolicy': 'MANUAL_ONLY'},
    ),
  );
  return ready;
}
