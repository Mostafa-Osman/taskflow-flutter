import 'package:dio/dio.dart';

import '../network/api_endpoints.dart';
import 'authorization_service.dart';
import 'class_mapping_service.dart';
import 'classroom_client.dart';
import 'enums.dart';
import 'grade_publication_capability_service.dart';
import 'grade_publication_policy_service.dart';
import 'grade_publication_service.dart';
import 'mock_classroom_client.dart';

class ClassroomBackend {
  ClassroomBackend({
    ClassroomClient? classroomClient,
    AuthorizationService? authorization,
    ClassMappingService? mappingService,
    GradePublicationPolicyService? policyService,
  }) : classroomClient = classroomClient ?? MockClassroomClient(),
       _authz = authorization ?? const AuthorizationService(),
       _mapping = mappingService ?? const ClassMappingService(),
       _policy = policyService ?? const GradePublicationPolicyService() {
    _capability = GradePublicationCapabilityService(this.classroomClient);
    _publication = GradePublicationService(
      client: this.classroomClient,
      policyService: _policy,
      capabilityService: _capability,
    );
  }

  final ClassroomClient classroomClient;
  final AuthorizationService _authz;
  final ClassMappingService _mapping;
  final GradePublicationPolicyService _policy;
  late final GradePublicationCapabilityService _capability;
  late final GradePublicationService _publication;

  final List<Map<String, dynamic>> classes = [];
  final List<Map<String, dynamic>> connections = [];
  final List<Map<String, dynamic>> mappings = [];
  final List<Map<String, dynamic>> students = [];
  final List<Map<String, dynamic>> coursework = [];
  final List<Map<String, dynamic>> courseworkPolicies = [];
  final List<Map<String, dynamic>> gradingResults = [];
  final List<Map<String, dynamic>> publicationAttempts = [];

  int _seq = 0;

  String nextId(String prefix) => '$prefix-${++_seq}';

  Future<void> refreshAllCapabilities() async {
    for (final item in coursework) {
      await _refreshCapability(item);
    }
  }

  void assignUserToClass({
    required Map<String, dynamic> user,
    required String classId,
    String? subject,
  }) {
    final assigned = List<String>.from(user['assignedClassIds'] as List? ?? []);
    if (!assigned.contains(classId)) {
      assigned.add(classId);
    }
    user['assignedClassIds'] = assigned;
    if (subject != null) {
      user['assignedSubject'] = subject;
    }
  }

  Future<Response<dynamic>?> handle(
    RequestOptions options,
    Map<String, dynamic>? user,
  ) async {
    final path = options.uri.path;
    final method = options.method.toUpperCase();

    if (!_isClassroomPath(path)) {
      return null;
    }
    if (user == null) {
      return _error(options, 401, 'Unauthorized');
    }

    if (path == ApiEndpoints.classes && method == 'POST') {
      return _createClass(options, user);
    }
    if (path == ApiEndpoints.classes && method == 'GET') {
      return _listClasses(options, user);
    }
    final classMatch = RegExp(r'^/classes/([^/]+)$').firstMatch(path);
    if (classMatch != null && method == 'GET') {
      return _getClass(options, user, classMatch.group(1)!);
    }
    final mapMatch = RegExp(r'^/classes/([^/]+)/mappings$').firstMatch(path);
    if (mapMatch != null && method == 'POST') {
      return _mapClass(options, user, mapMatch.group(1)!);
    }
    final unmapMatch = RegExp(
      r'^/classes/([^/]+)/mappings/([^/]+)$',
    ).firstMatch(path);
    if (unmapMatch != null && method == 'DELETE') {
      return _unmapClass(
        options,
        user,
        unmapMatch.group(1)!,
        unmapMatch.group(2)!,
      );
    }
    final syncMatch = RegExp(r'^/classes/([^/]+)/sync$').firstMatch(path);
    if (syncMatch != null && method == 'POST') {
      return _syncClass(options, user, syncMatch.group(1)!);
    }
    final classWork = RegExp(r'^/classes/([^/]+)/coursework$').firstMatch(path);
    if (classWork != null && method == 'GET') {
      return _listClassCoursework(options, user, classWork.group(1)!);
    }
    if (path == ApiEndpoints.googleClassroomConnect && method == 'POST') {
      return _connect(options, user);
    }
    if (path == ApiEndpoints.googleClassroomDisconnect && method == 'POST') {
      return _disconnect(options, user);
    }
    if (path == ApiEndpoints.googleClassroomCourses && method == 'GET') {
      return _listExternalCourses(options, user);
    }
    if (path == ApiEndpoints.googleClassroomImport && method == 'POST') {
      return _importCourses(options, user);
    }
    if (path == ApiEndpoints.googleClassroomSettings && method == 'GET') {
      return _getSettings(options, user);
    }
    if (path == ApiEndpoints.googleClassroomSettings && method == 'PATCH') {
      return _patchSettings(options, user);
    }
    final workMatch = RegExp(r'^/coursework/([^/]+)$').firstMatch(path);
    if (workMatch != null && method == 'GET') {
      return _getCoursework(options, user, workMatch.group(1)!);
    }
    final policyMatch = RegExp(
      r'^/coursework/([^/]+)/grade-policy$',
    ).firstMatch(path);
    if (policyMatch != null && method == 'GET') {
      return _getCourseworkPolicy(options, user, policyMatch.group(1)!);
    }
    if (policyMatch != null && method == 'PATCH') {
      return _patchCourseworkPolicy(options, user, policyMatch.group(1)!);
    }
    final summaryMatch = RegExp(
      r'^/coursework/([^/]+)/publication-summary$',
    ).firstMatch(path);
    if (summaryMatch != null && method == 'GET') {
      return _publicationSummary(options, user, summaryMatch.group(1)!);
    }
    final previewMatch = RegExp(
      r'^/coursework/([^/]+)/publication-preview$',
    ).firstMatch(path);
    if (previewMatch != null && method == 'GET') {
      return _publicationPreview(options, user, previewMatch.group(1)!);
    }
    final resultsMatch = RegExp(
      r'^/coursework/([^/]+)/results$',
    ).firstMatch(path);
    if (resultsMatch != null && method == 'POST') {
      return _createResult(options, user, resultsMatch.group(1)!);
    }
    final approveMatch = RegExp(r'^/grades/([^/]+)/approve$').firstMatch(path);
    if (approveMatch != null && method == 'POST') {
      return _approveResult(options, user, approveMatch.group(1)!);
    }
    if (path == ApiEndpoints.gradePublications && method == 'POST') {
      return _publishGrades(options, user);
    }
    final retryMatch = RegExp(
      r'^/grades/publications/([^/]+)/retry$',
    ).firstMatch(path);
    if (retryMatch != null && method == 'POST') {
      return _retryPublication(options, user, retryMatch.group(1)!);
    }

    return _error(options, 404, 'Unknown classroom endpoint.');
  }

  bool _isClassroomPath(String path) {
    return path.startsWith('/classes') ||
        path.startsWith('/integrations/google-classroom') ||
        path.startsWith('/coursework') ||
        path.startsWith('/grades');
  }

  Response<dynamic> _createClass(
    RequestOptions options,
    Map<String, dynamic> user,
  ) {
    final body = _body(options);
    final name = (body['name'] as String? ?? '').trim();
    if (name.isEmpty) {
      return _error(options, 400, 'Name is required.');
    }
    final now = _now();
    final schoolClass = <String, dynamic>{
      'id': nextId('cls'),
      'tenantId': user['tenantId'],
      'ownerTeacherId': user['id'],
      'organizationId': body['organizationId'] ?? user['organizationId'],
      'name': name,
      'localNameOverride': name,
      'description': (body['description'] as String? ?? '').trim(),
      'sourceType': ClassSourceType.native.apiValue,
      'status': ClassStatus.active.apiValue,
      'subject': body['subject'],
      'createdAt': now,
      'updatedAt': now,
    };
    classes.add(schoolClass);
    return _ok(options, _classJson(schoolClass), statusCode: 201);
  }

  Response<dynamic> _listClasses(
    RequestOptions options,
    Map<String, dynamic> user,
  ) {
    final query = options.queryParameters;
    var filtered = classes
        .where((item) => item['tenantId'] == user['tenantId'])
        .toList();
    final source = query['source'] as String?;
    final status = query['status'] as String?;
    final subject = query['subject'] as String?;
    final teacher = query['teacher'] as String?;
    final organization = query['organization'] as String?;
    final connected = query['connected'] as String?;
    final syncIssue = query['syncIssue'] as String?;

    if (source != null && source.isNotEmpty) {
      filtered = filtered.where((item) => item['sourceType'] == source).toList();
    }
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((item) => item['status'] == status).toList();
    }
    if (subject != null && subject.isNotEmpty) {
      filtered = filtered.where((item) => item['subject'] == subject).toList();
    }
    if (teacher != null && teacher.isNotEmpty) {
      filtered = filtered
          .where((item) => item['ownerTeacherId'] == teacher)
          .toList();
    }
    if (organization != null && organization.isNotEmpty) {
      filtered = filtered
          .where((item) => item['organizationId'] == organization)
          .toList();
    }
    if (connected == 'true') {
      filtered = filtered.where(_isGoogleConnected).toList();
    }
    if (syncIssue == 'true') {
      filtered = filtered.where(_hasSyncIssue).toList();
    }
    return _ok(options, filtered.map(_classJson).toList());
  }

  Response<dynamic> _getClass(
    RequestOptions options,
    Map<String, dynamic> user,
    String id,
  ) {
    final schoolClass = _classById(id);
    if (schoolClass == null || schoolClass['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Class not found.');
    }
    return _ok(options, _classJson(schoolClass));
  }

  Future<Response<dynamic>> _connect(
    RequestOptions options,
    Map<String, dynamic> user,
  ) async {
    if (!_authz.canManageIntegrations(user)) {
      return _error(options, 403, 'You cannot manage integrations.');
    }
    final existing = _connectionFor(user);
    final now = _now();
    if (existing != null) {
      existing
        ..['status'] = ConnectionStatus.connected.apiValue
        ..['updatedAt'] = now;
      return _ok(options, _connectionJson(existing));
    }
    final connection = <String, dynamic>{
      'id': nextId('conn'),
      'tenantId': user['tenantId'],
      'ownerTeacherId': user['id'],
      'provider': 'GOOGLE_CLASSROOM',
      'status': ConnectionStatus.connected.apiValue,
      'gradeSyncPolicy': ConnectionGradeSyncPolicy.disabled.apiValue,
      'capabilityState': CapabilityState.unknown.apiValue,
      'checkedAt': null,
      'lastSuccessfulCheckAt': null,
      'lastErrorCode': null,
      'lastErrorMessage': null,
      'capabilityVersion': 'v1',
      'createdAt': now,
      'updatedAt': now,
    };
    connections.add(connection);
    return _ok(options, _connectionJson(connection), statusCode: 201);
  }

  Response<dynamic> _disconnect(
    RequestOptions options,
    Map<String, dynamic> user,
  ) {
    if (!_authz.canManageIntegrations(user)) {
      return _error(options, 403, 'You cannot manage integrations.');
    }
    final connection = _connectionFor(user);
    if (connection == null) {
      return _error(options, 404, 'Google Classroom is not connected.');
    }
    connection
      ..['status'] = ConnectionStatus.disconnected.apiValue
      ..['updatedAt'] = _now();
    return _ok(options, {
      'connection': _connectionJson(connection),
      'preservedClassIds': classes
          .where((item) => item['tenantId'] == user['tenantId'])
          .map((item) => item['id'])
          .toList(),
      'preservedStudentCount': students
          .where((item) => item['tenantId'] == user['tenantId'])
          .length,
      'preservedResultCount': gradingResults
          .where((item) => item['tenantId'] == user['tenantId'])
          .length,
    });
  }

  Future<Response<dynamic>> _listExternalCourses(
    RequestOptions options,
    Map<String, dynamic> user,
  ) async {
    final connection = _requireConnected(options, user);
    if (connection is Response<dynamic>) {
      return connection;
    }
    try {
      final courses = await classroomClient.listCourses(
        connectionId: (connection as Map<String, dynamic>)['id'] as String,
      );
      return _ok(options, courses.map((course) => course.toJson()).toList());
    } on ClassroomClientException catch (error) {
      return _mapClientError(options, user, error);
    }
  }

  Future<Response<dynamic>> _importCourses(
    RequestOptions options,
    Map<String, dynamic> user,
  ) async {
    final connection = _requireConnected(options, user);
    if (connection is Response<dynamic>) {
      return connection;
    }
    final ids = List<String>.from(
      (_body(options)['courseIds'] as List<dynamic>? ?? const []),
    );
    if (ids.isEmpty) {
      return _error(options, 400, 'Select at least one course to import.');
    }
    try {
      final available = await classroomClient.listCourses(
        connectionId: (connection as Map<String, dynamic>)['id'] as String,
      );
      final imported = <Map<String, dynamic>>[];
      for (final courseId in ids) {
        final course = available.cast<ExternalCourse?>().firstWhere(
          (item) => item!.id == courseId,
          orElse: () => null,
        );
        if (course == null) {
          continue;
        }
        final outcome = _mapping.importCourse(
          user: user,
          connection: connection,
          course: course.toJson(),
          classes: classes,
          mappings: mappings,
          now: _now(),
          nextId: nextId,
        );
        if (!outcome.alreadyExisted) {
          classes.add(outcome.schoolClass);
          mappings.add(outcome.mapping);
          await _hydrateExternal(outcome.schoolClass, outcome.mapping, course);
        }
        imported.add(_classJson(outcome.schoolClass));
      }
      return _ok(options, imported, statusCode: 201);
    } on ClassroomClientException catch (error) {
      return _mapClientError(options, user, error);
    }
  }

  Future<Response<dynamic>> _mapClass(
    RequestOptions options,
    Map<String, dynamic> user,
    String classId,
  ) async {
    final schoolClass = _classById(classId);
    if (schoolClass == null || schoolClass['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Class not found.');
    }
    final connection = _requireConnected(options, user);
    if (connection is Response<dynamic>) {
      return connection;
    }
    final body = _body(options);
    final courseId = body['externalCourseId'] as String? ?? '';
    final confirmed = body['confirmed'] == true;
    try {
      final available = await classroomClient.listCourses(
        connectionId: (connection as Map<String, dynamic>)['id'] as String,
      );
      final course = available.cast<ExternalCourse?>().firstWhere(
        (item) => item!.id == courseId,
        orElse: () => null,
      );
      final validation = _mapping.validateMap(
        user: user,
        schoolClass: schoolClass,
        connection: connection,
        externalCourseId: courseId,
        courseVisible: course != null,
        confirmed: confirmed,
        mappings: mappings,
      );
      if (!validation.isValid) {
        return _error(options, 400, validation.error!);
      }
      final now = _now();
      final mapping = <String, dynamic>{
        'id': nextId('map'),
        'tenantId': user['tenantId'],
        'internalClassId': classId,
        'externalConnectionId': connection['id'],
        'provider': 'GOOGLE_CLASSROOM',
        'externalCourseId': courseId,
        'mappingStatus': MappingStatus.active.apiValue,
        'createdBy': user['id'],
        'createdAt': now,
        'updatedAt': now,
      };
      mappings.add(mapping);
      await _hydrateExternal(schoolClass, mapping, course!);
      return _ok(options, _classJson(schoolClass), statusCode: 201);
    } on ClassroomClientException catch (error) {
      return _mapClientError(options, user, error);
    }
  }

  Response<dynamic> _unmapClass(
    RequestOptions options,
    Map<String, dynamic> user,
    String classId,
    String mappingId,
  ) {
    final schoolClass = _classById(classId);
    if (schoolClass == null || schoolClass['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Class not found.');
    }
    if (!_authz.canManageClass(user, schoolClass)) {
      return _error(options, 403, 'You cannot unmap this class.');
    }
    final mapping = mappings.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item!['id'] == mappingId && item['internalClassId'] == classId,
      orElse: () => null,
    );
    if (mapping == null) {
      return _error(options, 404, 'Mapping not found.');
    }
    mapping
      ..['mappingStatus'] = MappingStatus.unmapped.apiValue
      ..['updatedAt'] = _now();
    return _ok(options, {
      'class': _classJson(schoolClass),
      'mapping': mapping,
      'preservedStudentCount': students
          .where((item) => item['classId'] == classId)
          .length,
      'preservedResultCount': gradingResults
          .where((item) => item['classId'] == classId)
          .length,
    });
  }

  Future<Response<dynamic>> _syncClass(
    RequestOptions options,
    Map<String, dynamic> user,
    String classId,
  ) async {
    final schoolClass = _classById(classId);
    if (schoolClass == null || schoolClass['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Class not found.');
    }
    final mapping = _activeMappingForClass(classId);
    if (mapping == null) {
      return _error(options, 400, 'Class has no active mapping.');
    }
    final connection = _connectionById(
      mapping['externalConnectionId'] as String,
    );
    if (connection == null ||
        connection['status'] != ConnectionStatus.connected.apiValue) {
      return _error(options, 400, 'Google Classroom is not connected.');
    }
    try {
      final courses = await classroomClient.listCourses(
        connectionId: connection['id'] as String,
      );
      final course = courses.firstWhere(
        (item) => item.id == mapping['externalCourseId'],
      );
      await _hydrateExternal(schoolClass, mapping, course, overwriteLocal: false);
      mapping['mappingStatus'] = MappingStatus.active.apiValue;
      return _ok(options, _classJson(schoolClass));
    } on ClassroomClientException catch (error) {
      mapping['mappingStatus'] = MappingStatus.syncError.apiValue;
      return _mapClientError(options, user, error);
    }
  }

  Response<dynamic> _listClassCoursework(
    RequestOptions options,
    Map<String, dynamic> user,
    String classId,
  ) {
    final schoolClass = _classById(classId);
    if (schoolClass == null || schoolClass['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Class not found.');
    }
    final items = coursework
        .where((item) => item['classId'] == classId)
        .map(_courseworkJson)
        .toList();
    return _ok(options, items);
  }

  Response<dynamic> _getSettings(
    RequestOptions options,
    Map<String, dynamic> user,
  ) {
    final connection = _connectionFor(user);
    if (connection == null) {
      return _error(options, 404, 'Google Classroom is not connected.');
    }
    return _ok(options, _connectionJson(connection));
  }

  Response<dynamic> _patchSettings(
    RequestOptions options,
    Map<String, dynamic> user,
  ) {
    if (!_authz.canManageIntegrations(user)) {
      return _error(options, 403, 'You cannot change integration settings.');
    }
    final connection = _connectionFor(user);
    if (connection == null) {
      return _error(options, 404, 'Google Classroom is not connected.');
    }
    if (connection['tenantId'] != user['tenantId']) {
      return _error(options, 403, 'You cannot change another tenant.');
    }
    final policy = _body(options)['gradeSyncPolicy'] as String?;
    if (policy != null) {
      connection['gradeSyncPolicy'] = policy;
    }
    connection['updatedAt'] = _now();
    return _ok(options, _connectionJson(connection));
  }

  Response<dynamic> _getCoursework(
    RequestOptions options,
    Map<String, dynamic> user,
    String id,
  ) {
    final item = _courseworkById(id);
    if (item == null || item['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Coursework not found.');
    }
    return _ok(options, _courseworkJson(item));
  }

  Response<dynamic> _getCourseworkPolicy(
    RequestOptions options,
    Map<String, dynamic> user,
    String id,
  ) {
    final item = _courseworkById(id);
    if (item == null || item['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Coursework not found.');
    }
    return _ok(options, _policyJson(item));
  }

  Response<dynamic> _patchCourseworkPolicy(
    RequestOptions options,
    Map<String, dynamic> user,
    String id,
  ) {
    final item = _courseworkById(id);
    if (item == null || item['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Coursework not found.');
    }
    final schoolClass = _classById(item['classId'] as String)!;
    if (!_authz.canManageClass(user, schoolClass)) {
      return _error(options, 403, 'You cannot change this coursework policy.');
    }
    final policy = _ensurePolicy(item);
    policy
      ..['gradeSyncPolicy'] =
          _body(options)['gradeSyncPolicy'] ?? policy['gradeSyncPolicy']
      ..['policyUpdatedBy'] = user['id']
      ..['policyUpdatedAt'] = _now();
    return _ok(options, _policyJson(item));
  }

  Response<dynamic> _publicationSummary(
    RequestOptions options,
    Map<String, dynamic> user,
    String id,
  ) {
    final item = _courseworkById(id);
    if (item == null || item['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Coursework not found.');
    }
    return _ok(options, _summaryJson(item, user));
  }

  Response<dynamic> _publicationPreview(
    RequestOptions options,
    Map<String, dynamic> user,
    String id,
  ) {
    final item = _courseworkById(id);
    if (item == null || item['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Coursework not found.');
    }
    final results = gradingResults
        .where((result) => result['courseworkId'] == id)
        .map((result) => _previewItem(item, result, user))
        .toList();
    return _ok(options, {
      'coursework': _courseworkJson(item),
      'items': results,
    });
  }

  Response<dynamic> _createResult(
    RequestOptions options,
    Map<String, dynamic> user,
    String courseworkId,
  ) {
    final item = _courseworkById(courseworkId);
    if (item == null || item['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Coursework not found.');
    }
    final body = _body(options);
    final score = _asDouble(body['score']);
    final maxScore = _asDouble(item['maxPoints']) ?? 100;
    if (score == null || score < 0 || score > maxScore) {
      return _error(options, 400, 'Score must be within the maximum points.');
    }
    final now = _now();
    final result = <String, dynamic>{
      'id': nextId('gr'),
      'tenantId': user['tenantId'],
      'classId': item['classId'],
      'courseworkId': courseworkId,
      'studentId': body['studentId'],
      'googleUserId': body['googleUserId'],
      'score': score,
      'maxScore': maxScore,
      'approved': false,
      'approvedBy': null,
      'createdAt': now,
      'updatedAt': now,
    };
    gradingResults.add(result);
    return _ok(options, result, statusCode: 201);
  }

  Future<Response<dynamic>> _approveResult(
    RequestOptions options,
    Map<String, dynamic> user,
    String resultId,
  ) async {
    final result = gradingResults.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item!['id'] == resultId,
      orElse: () => null,
    );
    if (result == null || result['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Grading result not found.');
    }
    final item = _courseworkById(result['courseworkId'] as String)!;
    final schoolClass = _classById(item['classId'] as String)!;
    if (!_authz.canApproveGrades(
      user,
      schoolClass,
      subject: schoolClass['subject'] as String?,
    )) {
      return _error(options, 403, 'You cannot approve this grade.');
    }
    result
      ..['approved'] = true
      ..['approvedBy'] = user['id']
      ..['updatedAt'] = _now();

    final createdJob = await _maybeEnqueueAfterApproval(user, item, result);
    return _ok(options, {
      'result': result,
      'publicationAttempt': createdJob,
      'published': createdJob != null &&
          createdJob['status'] == PublicationAttemptStatus.succeeded.apiValue,
    });
  }

  Future<Response<dynamic>> _publishGrades(
    RequestOptions options,
    Map<String, dynamic> user,
  ) async {
    final body = _body(options);
    final resultIds = List<String>.from(
      body['resultIds'] as List<dynamic>? ?? const [],
    );
    if (resultIds.isEmpty) {
      return _error(options, 400, 'Select at least one grading result.');
    }
    final attempts = <Map<String, dynamic>>[];
    for (final resultId in resultIds) {
      final result = gradingResults.cast<Map<String, dynamic>?>().firstWhere(
        (item) => item!['id'] == resultId,
        orElse: () => null,
      );
      if (result == null) {
        return _error(options, 404, 'Grading result not found.');
      }
      final item = _courseworkById(result['courseworkId'] as String)!;
      final attempt = await _enqueuePublication(
        user: user,
        item: item,
        result: result,
        mode: PublicationMode.manual,
        idempotencyKey: body['idempotencyKey'] as String? ??
            'manual-$resultId-${result['updatedAt']}',
      );
      if (attempt['error'] != null) {
        return _error(
          options,
          attempt['statusCode'] as int? ?? 400,
          attempt['error'] as String,
        );
      }
      attempts.add(attempt);
    }
    return _ok(options, attempts);
  }

  Future<Response<dynamic>> _retryPublication(
    RequestOptions options,
    Map<String, dynamic> user,
    String attemptId,
  ) async {
    final attempt = publicationAttempts.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item!['id'] == attemptId,
      orElse: () => null,
    );
    if (attempt == null || attempt['tenantId'] != user['tenantId']) {
      return _error(options, 404, 'Publication attempt not found.');
    }
    final result = gradingResults.firstWhere(
      (item) => item['id'] == attempt['gradingResultId'],
    );
    final item = _courseworkById(result['courseworkId'] as String)!;
    final schoolClass = _classById(item['classId'] as String)!;
    if (!_authz.canPublishGrades(
      user,
      schoolClass,
      subject: schoolClass['subject'] as String?,
    )) {
      return _error(options, 403, 'You cannot publish grades for this class.');
    }
    final executed = await _publication.executeAttempt(
      attempt: attempt,
      courseworkId: item['externalCourseworkId'] as String,
      googleUserId: result['googleUserId'] as String,
      requestedGrade: _asDouble(result['score'])!,
      now: _now(),
    );
    return _ok(options, executed);
  }

  Future<Map<String, dynamic>?> _maybeEnqueueAfterApproval(
    Map<String, dynamic> user,
    Map<String, dynamic> item,
    Map<String, dynamic> result,
  ) async {
    final decision = _publication.canEnqueue(
      policy: _effectivePolicy(item),
      capability: CapabilityState.fromApi(item['capabilityState'] as String?),
      mode: PublicationMode.afterTeacherApproval,
      hasPublishPermission: _authz.canPublishGrades(
        user,
        _classById(item['classId'] as String)!,
        subject: _classById(item['classId'] as String)!['subject'] as String?,
      ),
      connectionStatus: _connectionStatusFor(item),
      approved: true,
    );
    if (!decision.allowed) {
      return null;
    }
    return _enqueuePublication(
      user: user,
      item: item,
      result: result,
      mode: PublicationMode.afterTeacherApproval,
      idempotencyKey: 'approve-${result['id']}-${result['updatedAt']}',
    );
  }

  Future<Map<String, dynamic>> _enqueuePublication({
    required Map<String, dynamic> user,
    required Map<String, dynamic> item,
    required Map<String, dynamic> result,
    required PublicationMode mode,
    required String idempotencyKey,
  }) async {
    final schoolClass = _classById(item['classId'] as String)!;
    if (result['tenantId'] != user['tenantId'] ||
        schoolClass['tenantId'] != user['tenantId']) {
      return {
        'error': 'You cannot publish grades for another tenant.',
        'statusCode': 403,
      };
    }
    if (!_authz.canPublishGrades(
      user,
      schoolClass,
      subject: schoolClass['subject'] as String?,
    )) {
      return {
        'error': 'You cannot publish grades for this class.',
        'statusCode': 403,
      };
    }
    final existing = publicationAttempts.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item!['idempotencyKey'] == idempotencyKey,
      orElse: () => null,
    );
    if (existing != null) {
      return existing;
    }
    final decision = _publication.canEnqueue(
      policy: _effectivePolicy(item),
      capability: CapabilityState.fromApi(item['capabilityState'] as String?),
      mode: mode,
      hasPublishPermission: true,
      connectionStatus: _connectionStatusFor(item),
      approved: result['approved'] == true,
    );
    if (!decision.allowed) {
      return {'error': decision.blockedReason, 'statusCode': 400};
    }
    if (item['externalCourseworkId'] == null || result['googleUserId'] == null) {
      return {
        'error': 'The assignment does not support the requested API operation.',
        'statusCode': 400,
      };
    }
    final now = _now();
    final attempt = <String, dynamic>{
      'id': nextId('pub'),
      'tenantId': user['tenantId'],
      'gradingResultId': result['id'],
      'externalSubmissionId': null,
      'requestedBy': user['id'],
      'publicationMode': mode.apiValue,
      'status': PublicationAttemptStatus.pending.apiValue,
      'idempotencyKey': idempotencyKey,
      'attemptCount': 0,
      'externalGradeBefore': null,
      'requestedGrade': result['score'],
      'externalGradeAfter': null,
      'lastErrorCode': null,
      'lastErrorMessage': null,
      'createdAt': now,
      'completedAt': null,
    };
    publicationAttempts.add(attempt);
    return _publication.executeAttempt(
      attempt: attempt,
      courseworkId: item['externalCourseworkId'] as String,
      googleUserId: result['googleUserId'] as String,
      requestedGrade: _asDouble(result['score'])!,
      now: now,
    );
  }

  Future<void> _hydrateExternal(
    Map<String, dynamic> schoolClass,
    Map<String, dynamic> mapping,
    ExternalCourse course, {
    bool overwriteLocal = false,
  }) async {
    schoolClass['externalSnapshot'] = {
      'name': course.name,
      'section': course.section,
      'room': course.room,
      'externalCourseId': course.id,
      'subject': course.subject,
    };
    if (overwriteLocal) {
      schoolClass['name'] = course.name;
      schoolClass['subject'] = course.subject;
    }
    schoolClass['updatedAt'] = _now();
    final roster = await classroomClient.listStudents(courseId: course.id);
    for (final incoming in roster) {
      final link = _mapping.linkStudent(
        incoming: {
          'googleUserId': incoming.googleUserId,
          'email': incoming.email,
          'displayName': incoming.displayName,
          'phone': incoming.phone,
          'verifiedEmail': incoming.verifiedEmail,
        },
        existingStudents: students
            .where((item) => item['classId'] == schoolClass['id'])
            .toList(),
        tenantId: schoolClass['tenantId'] as String,
        classId: schoolClass['id'] as String,
        now: _now(),
        nextId: nextId,
      );
      if (link.status == RosterLinkStatus.unmatched &&
          !students.any((item) => item['id'] == link.student['id'])) {
        students.add(link.student);
      } else {
        link.student['linkStatus'] = link.status.apiValue;
      }
    }
    final works = await classroomClient.listCoursework(courseId: course.id);
    for (final work in works) {
      final existing = coursework.cast<Map<String, dynamic>?>().firstWhere(
        (item) =>
            item!['classId'] == schoolClass['id'] &&
            item['externalCourseworkId'] == work.id,
        orElse: () => null,
      );
      if (existing != null) {
        existing['externalTitle'] = work.title;
        existing['maxPoints'] = work.maxPoints;
        continue;
      }
      final now = _now();
      final record = <String, dynamic>{
        'id': nextId('cw'),
        'tenantId': schoolClass['tenantId'],
        'classId': schoolClass['id'],
        'connectionId': mapping['externalConnectionId'],
        'title': work.title,
        'externalTitle': work.title,
        'maxPoints': work.maxPoints,
        'externalCourseworkId': work.id,
        'createdByThisProject': work.createdByThisProject,
        'capabilityState': CapabilityState.unknown.apiValue,
        'checkedAt': null,
        'lastSuccessfulCheckAt': null,
        'lastErrorCode': null,
        'lastErrorMessage': null,
        'capabilityVersion': 'v1',
        'createdAt': now,
        'updatedAt': now,
      };
      coursework.add(record);
      courseworkPolicies.add({
        'courseworkId': record['id'],
        'connectionId': mapping['externalConnectionId'],
        'gradeSyncPolicy':
            CourseworkGradeSyncPolicy.inheritConnectionDefault.apiValue,
        'policyUpdatedBy': mapping['createdBy'],
        'policyUpdatedAt': now,
      });
      await _refreshCapability(record);
    }
  }

  Future<void> _refreshCapability(Map<String, dynamic> item) async {
    final check = await _capability.check(
      connectionId: item['connectionId'] as String? ?? '',
      courseworkId: item['externalCourseworkId'] as String,
      now: _now(),
      lastSuccessfulCheckAt: item['lastSuccessfulCheckAt'] as String?,
    );
    item
      ..['capabilityState'] = check.state.apiValue
      ..['checkedAt'] = check.checkedAt
      ..['lastSuccessfulCheckAt'] = check.lastSuccessfulCheckAt
      ..['lastErrorCode'] = check.lastErrorCode
      ..['lastErrorMessage'] = check.lastErrorMessage
      ..['capabilityVersion'] = check.capabilityVersion;
  }

  Object _requireConnected(RequestOptions options, Map<String, dynamic> user) {
    if (!_authz.canManageIntegrations(user) &&
        options.method.toUpperCase() != 'GET') {
      return _error(options, 403, 'You cannot manage integrations.');
    }
    final connection = _connectionFor(user);
    if (connection == null) {
      return _error(options, 404, 'Google Classroom is not connected.');
    }
    if (connection['status'] ==
        ConnectionStatus.requiresReauthorization.apiValue) {
      return _error(
        options,
        401,
        'The Google Classroom connection has expired and must be reauthorized.',
      );
    }
    if (connection['status'] != ConnectionStatus.connected.apiValue) {
      return _error(options, 400, 'Google Classroom is disconnected.');
    }
    return connection;
  }

  Response<dynamic> _mapClientError(
    RequestOptions options,
    Map<String, dynamic> user,
    ClassroomClientException error,
  ) {
    final connection = _connectionFor(user);
    if (connection != null &&
        error.capability == CapabilityState.requiresReauthorization) {
      connection['status'] = ConnectionStatus.requiresReauthorization.apiValue;
    }
    final status = switch (error.capability) {
      CapabilityState.requiresReauthorization => 401,
      CapabilityState.permissionDenied => 403,
      _ => 503,
    };
    return _error(options, status, error.message);
  }

  Map<String, dynamic> _classJson(Map<String, dynamic> schoolClass) {
    final mapping = _activeMappingForClass(schoolClass['id'] as String);
    return {
      ...schoolClass,
      'mapping': mapping,
      'connected': mapping != null,
      'hasSyncIssue': _hasSyncIssue(schoolClass),
    };
  }

  Map<String, dynamic> _connectionJson(Map<String, dynamic> connection) {
    return Map<String, dynamic>.from(connection);
  }

  Map<String, dynamic> _courseworkJson(Map<String, dynamic> item) {
    return {
      ...item,
      'policy': _policyJson(item),
      'publicationSummary': _countSummary(item),
    };
  }

  Map<String, dynamic> _policyJson(Map<String, dynamic> item) {
    final policy = _ensurePolicy(item);
    final effective = _effectivePolicy(item);
    return {
      ...policy,
      'effectivePolicy': effective.apiValue,
    };
  }

  Map<String, dynamic> _summaryJson(
    Map<String, dynamic> item,
    Map<String, dynamic> user,
  ) {
    return {
      ..._courseworkJson(item),
      'unavailableReason': _capability.unavailableReason(
        capability: CapabilityState.fromApi(item['capabilityState'] as String?),
        policy: _effectivePolicy(item),
        hasPublishPermission: _authz.canPublishGrades(
          user,
          _classById(item['classId'] as String)!,
          subject: _classById(item['classId'] as String)!['subject'] as String?,
        ),
        connectionStatus: _connectionStatusFor(item),
        hasSubmission: true,
        hasConflict: _countByStatus(item, PublicationAttemptStatus.conflict) > 0,
      ),
    };
  }

  Map<String, dynamic> _countSummary(Map<String, dynamic> item) {
    final related = gradingResults
        .where((result) => result['courseworkId'] == item['id'])
        .toList();
    final attempts = publicationAttempts
        .where(
          (attempt) => related.any(
            (result) => result['id'] == attempt['gradingResultId'],
          ),
        )
        .toList();
    return {
      'eligibleCount': related.where((result) => result['approved'] == true).length,
      'blockedCount': related.where((result) => result['approved'] != true).length,
      'pendingCount': attempts
          .where(
            (attempt) =>
                attempt['status'] == PublicationAttemptStatus.pending.apiValue ||
                attempt['status'] == PublicationAttemptStatus.inProgress.apiValue,
          )
          .length,
      'successCount': attempts
          .where(
            (attempt) =>
                attempt['status'] == PublicationAttemptStatus.succeeded.apiValue,
          )
          .length,
      'failedCount': attempts
          .where(
            (attempt) =>
                attempt['status'] == PublicationAttemptStatus.failed.apiValue,
          )
          .length,
      'conflictCount': attempts
          .where(
            (attempt) =>
                attempt['status'] == PublicationAttemptStatus.conflict.apiValue,
          )
          .length,
    };
  }

  Map<String, dynamic> _previewItem(
    Map<String, dynamic> item,
    Map<String, dynamic> result,
    Map<String, dynamic> user,
  ) {
    final schoolClass = _classById(item['classId'] as String)!;
    final decision = _publication.canEnqueue(
      policy: _effectivePolicy(item),
      capability: CapabilityState.fromApi(item['capabilityState'] as String?),
      mode: PublicationMode.manual,
      hasPublishPermission: _authz.canPublishGrades(
        user,
        schoolClass,
        subject: schoolClass['subject'] as String?,
      ),
      connectionStatus: _connectionStatusFor(item),
      approved: result['approved'] == true,
    );
    return {
      'result': result,
      'eligible': decision.allowed,
      'blockedReason': decision.blockedReason,
    };
  }

  Map<String, dynamic> _ensurePolicy(Map<String, dynamic> item) {
    final existing = courseworkPolicies.cast<Map<String, dynamic>?>().firstWhere(
      (policy) => policy!['courseworkId'] == item['id'],
      orElse: () => null,
    );
    if (existing != null) {
      return existing;
    }
    final created = <String, dynamic>{
      'courseworkId': item['id'],
      'connectionId': item['connectionId'],
      'gradeSyncPolicy':
          CourseworkGradeSyncPolicy.inheritConnectionDefault.apiValue,
      'policyUpdatedBy': null,
      'policyUpdatedAt': null,
    };
    courseworkPolicies.add(created);
    return created;
  }

  EffectiveGradeSyncPolicy _effectivePolicy(Map<String, dynamic> item) {
    final policy = _ensurePolicy(item);
    final connection = _connectionById(item['connectionId'] as String? ?? '');
    return _policy.resolve(
      connection: ConnectionGradeSyncPolicy.fromApi(
        connection?['gradeSyncPolicy'] as String?,
      ),
      coursework: CourseworkGradeSyncPolicy.fromApi(
        policy['gradeSyncPolicy'] as String?,
      ),
    );
  }

  ConnectionStatus _connectionStatusFor(Map<String, dynamic> item) {
    final connection = _connectionById(item['connectionId'] as String? ?? '');
    return ConnectionStatus.fromApi(connection?['status'] as String?);
  }

  int _countByStatus(Map<String, dynamic> item, PublicationAttemptStatus status) {
    return publicationAttempts.where((attempt) {
      final result = gradingResults.cast<Map<String, dynamic>?>().firstWhere(
        (item) => item!['id'] == attempt['gradingResultId'],
        orElse: () => null,
      );
      return result != null &&
          result['courseworkId'] == item['id'] &&
          attempt['status'] == status.apiValue;
    }).length;
  }

  bool _isGoogleConnected(Map<String, dynamic> schoolClass) {
    return _activeMappingForClass(schoolClass['id'] as String) != null;
  }

  bool _hasSyncIssue(Map<String, dynamic> schoolClass) {
    return mappings.any((mapping) {
      return mapping['internalClassId'] == schoolClass['id'] &&
          (mapping['mappingStatus'] == MappingStatus.conflict.apiValue ||
              mapping['mappingStatus'] == MappingStatus.syncError.apiValue);
    });
  }

  Map<String, dynamic>? _classById(String id) {
    return classes.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item!['id'] == id,
      orElse: () => null,
    );
  }

  Map<String, dynamic>? _courseworkById(String id) {
    return coursework.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item!['id'] == id,
      orElse: () => null,
    );
  }

  Map<String, dynamic>? _connectionFor(Map<String, dynamic> user) {
    return connections.cast<Map<String, dynamic>?>().firstWhere(
      (item) =>
          item!['tenantId'] == user['tenantId'] &&
          item['ownerTeacherId'] == user['id'],
      orElse: () => null,
    );
  }

  Map<String, dynamic>? _connectionById(String id) {
    return connections.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item!['id'] == id,
      orElse: () => null,
    );
  }

  Map<String, dynamic>? _activeMappingForClass(String classId) {
    return mappings.cast<Map<String, dynamic>?>().firstWhere(
      (item) =>
          item!['internalClassId'] == classId &&
          item['mappingStatus'] == MappingStatus.active.apiValue,
      orElse: () => null,
    );
  }

  Map<String, dynamic> _body(RequestOptions options) {
    final data = options.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  double? _asDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse('$value');
  }

  String _now() => DateTime.now().toUtc().toIso8601String();

  Response<dynamic> _ok(
    RequestOptions options,
    Object? data, {
    int statusCode = 200,
  }) {
    return Response<dynamic>(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
    );
  }

  Response<dynamic> _error(
    RequestOptions options,
    int statusCode,
    String message,
  ) {
    return Response<dynamic>(
      requestOptions: options,
      statusCode: statusCode,
      data: {'message': message},
    );
  }
}
