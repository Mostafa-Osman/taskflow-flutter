import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../constants/storage_keys.dart';
import '../storage/local_preferences.dart';
import 'api_endpoints.dart';

class MockBackendStore {
  MockBackendStore({required LocalPreferences preferences})
    : _preferences = preferences;

  final LocalPreferences _preferences;
  final Random _random = Random(42);

  final List<Map<String, dynamic>> _users = [];
  final Map<String, String> _tokens = {};
  final List<Map<String, dynamic>> _projects = [];
  final List<Map<String, dynamic>> _tasks = [];
  final List<Map<String, dynamic>> _notifications = [];

  bool _seeded = false;

  Future<void> initialize() async {
    if (_seeded) {
      return;
    }
    _seedProjects();
    _seedTasks();
    _seedNotifications();
    await _loadUsers();
    _seeded = true;
  }

  Future<Response<dynamic>> handle(RequestOptions options) async {
    await initialize();
    final path = options.uri.path;
    final method = options.method.toUpperCase();

    if (path == ApiEndpoints.login && method == 'POST') {
      return _login(options);
    }
    if (path == ApiEndpoints.register && method == 'POST') {
      return _register(options);
    }
    if (path == ApiEndpoints.me && method == 'GET') {
      return _me(options);
    }
    if (path == ApiEndpoints.projects && method == 'GET') {
      return _ok(options, _projectsWithCounts());
    }
    final projectMatch = RegExp(r'^/projects/([^/]+)$').firstMatch(path);
    if (projectMatch != null && method == 'GET') {
      return _project(options, projectMatch.group(1)!);
    }
    if (path == ApiEndpoints.tasks && method == 'GET') {
      return _listTasks(options);
    }
    if (path == ApiEndpoints.tasks && method == 'POST') {
      return _createTask(options);
    }
    final taskMatch = RegExp(r'^/tasks/([^/]+)$').firstMatch(path);
    if (taskMatch != null && method == 'GET') {
      return _task(options, taskMatch.group(1)!);
    }
    if (taskMatch != null && (method == 'PATCH' || method == 'PUT')) {
      return _updateTask(options, taskMatch.group(1)!);
    }
    if (taskMatch != null && method == 'DELETE') {
      return _deleteTask(options, taskMatch.group(1)!);
    }
    if (path == ApiEndpoints.notifications && method == 'GET') {
      return _ok(options, List<Map<String, dynamic>>.from(_notifications));
    }
    final readMatch = RegExp(r'^/notifications/([^/]+)/read$').firstMatch(path);
    if (readMatch != null && method == 'PATCH') {
      return _markRead(options, readMatch.group(1)!);
    }

    return _error(options, 404, 'Unknown endpoint.');
  }

  Response<dynamic> _login(RequestOptions options) {
    final body = _body(options);
    final email = (body['email'] as String? ?? '').trim().toLowerCase();
    final password = body['password'] as String? ?? '';
    final user = _users.cast<Map<String, dynamic>?>().firstWhere(
      (candidate) => candidate!['email'] == email,
      orElse: () => null,
    );
    if (user == null || user['password'] != password) {
      return _error(options, 401, 'Invalid email or password.');
    }
    return _ok(options, _issueSession(user));
  }

  Future<Response<dynamic>> _register(RequestOptions options) async {
    final body = _body(options);
    final email = (body['email'] as String? ?? '').trim().toLowerCase();
    final password = body['password'] as String? ?? '';
    final name = (body['name'] as String? ?? '').trim();
    if (email.isEmpty || password.length < 8 || name.length < 2) {
      return _error(options, 400, 'Name, email, and password are required.');
    }
    if (_users.any((user) => user['email'] == email)) {
      return _error(options, 400, 'An account with this email already exists.');
    }
    final user = <String, dynamic>{
      'id': 'u-${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'email': email,
      'password': password,
    };
    _users.add(user);
    await _persistUsers();
    return _ok(options, _issueSession(user), statusCode: 201);
  }

  Response<dynamic> _me(RequestOptions options) {
    final user = _userFromAuth(options);
    if (user == null) {
      return _error(options, 401, 'Unauthorized');
    }
    return _ok(options, _publicUser(user));
  }

  Response<dynamic> _project(RequestOptions options, String id) {
    final project = _projects.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item!['id'] == id,
      orElse: () => null,
    );
    if (project == null) {
      return _error(options, 404, 'Project not found.');
    }
    return _ok(options, _withCounts(project));
  }

  Response<dynamic> _listTasks(RequestOptions options) {
    final query = options.queryParameters;
    final page = int.tryParse('${query['page'] ?? 1}') ?? 1;
    final pageSize =
        int.tryParse('${query['pageSize'] ?? AppConstants.defaultPageSize}') ??
        AppConstants.defaultPageSize;
    final search = (query['query'] as String? ?? '').trim().toLowerCase();
    final status = query['status'] as String?;
    final priority = query['priority'] as String?;
    final projectId = query['projectId'] as String?;

    var filtered = List<Map<String, dynamic>>.from(_tasks);
    if (search.isNotEmpty) {
      filtered = filtered.where((task) {
        final title = (task['title'] as String).toLowerCase();
        final description = (task['description'] as String).toLowerCase();
        return title.contains(search) || description.contains(search);
      }).toList();
    }
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((task) => task['status'] == status).toList();
    }
    if (priority != null && priority.isNotEmpty) {
      filtered = filtered
          .where((task) => task['priority'] == priority)
          .toList();
    }
    if (projectId != null && projectId.isNotEmpty) {
      filtered = filtered
          .where((task) => task['projectId'] == projectId)
          .toList();
    }

    filtered.sort((a, b) {
      final left = DateTime.parse(a['updatedAt'] as String);
      final right = DateTime.parse(b['updatedAt'] as String);
      return right.compareTo(left);
    });

    final total = filtered.length;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    final items = start >= total
        ? <Map<String, dynamic>>[]
        : filtered.sublist(start, end > total ? total : end);

    return _ok(options, {
      'items': items,
      'page': page,
      'pageSize': pageSize,
      'total': total,
      'hasMore': end < total,
    });
  }

  Response<dynamic> _task(RequestOptions options, String id) {
    final task = _findTask(id);
    if (task == null) {
      return _error(options, 404, 'Task not found.');
    }
    return _ok(options, task);
  }

  Response<dynamic> _createTask(RequestOptions options) {
    final body = _body(options);
    final title = (body['title'] as String? ?? '').trim();
    final projectId = body['projectId'] as String? ?? '';
    if (title.isEmpty || projectId.isEmpty) {
      return _error(options, 400, 'Title and project are required.');
    }
    if (!_projects.any((project) => project['id'] == projectId)) {
      return _error(options, 400, 'Unknown project.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    final task = <String, dynamic>{
      'id': 't-${DateTime.now().millisecondsSinceEpoch}',
      'projectId': projectId,
      'title': title,
      'description': (body['description'] as String? ?? '').trim(),
      'status': body['status'] as String? ?? 'todo',
      'priority': body['priority'] as String? ?? 'medium',
      'dueDate': body['dueDate'],
      'createdAt': now,
      'updatedAt': now,
    };
    _tasks.insert(0, task);
    _notifications.insert(0, {
      'id': 'n-${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Task created',
      'body': '${task['title']} was added to your workspace.',
      'createdAt': now,
      'read': false,
      'taskId': task['id'],
    });
    return _ok(options, task, statusCode: 201);
  }

  Response<dynamic> _updateTask(RequestOptions options, String id) {
    final existing = _findTask(id);
    if (existing == null) {
      return _error(options, 404, 'Task not found.');
    }
    final body = _body(options);
    final previousStatus = existing['status'];
    existing
      ..['title'] = (body['title'] as String?)?.trim() ?? existing['title']
      ..['description'] =
          (body['description'] as String?)?.trim() ?? existing['description']
      ..['status'] = body['status'] ?? existing['status']
      ..['priority'] = body['priority'] ?? existing['priority']
      ..['dueDate'] = body.containsKey('dueDate')
          ? body['dueDate']
          : existing['dueDate']
      ..['projectId'] = body['projectId'] ?? existing['projectId']
      ..['updatedAt'] = DateTime.now().toUtc().toIso8601String();

    if (previousStatus != 'done' && existing['status'] == 'done') {
      _notifications.insert(0, {
        'id': 'n-${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Task completed',
        'body': '${existing['title']} was marked as done.',
        'createdAt': existing['updatedAt'],
        'read': false,
        'taskId': existing['id'],
      });
    }
    return _ok(options, existing);
  }

  Response<dynamic> _deleteTask(RequestOptions options, String id) {
    final index = _tasks.indexWhere((task) => task['id'] == id);
    if (index == -1) {
      return _error(options, 404, 'Task not found.');
    }
    _tasks.removeAt(index);
    return Response<dynamic>(
      requestOptions: options,
      statusCode: 204,
      data: null,
    );
  }

  Response<dynamic> _markRead(RequestOptions options, String id) {
    final notification = _notifications
        .cast<Map<String, dynamic>?>()
        .firstWhere((item) => item!['id'] == id, orElse: () => null);
    if (notification == null) {
      return _error(options, 404, 'Notification not found.');
    }
    notification['read'] = true;
    return _ok(options, notification);
  }

  Map<String, dynamic>? _findTask(String id) {
    return _tasks.cast<Map<String, dynamic>?>().firstWhere(
      (task) => task!['id'] == id,
      orElse: () => null,
    );
  }

  Map<String, dynamic> _issueSession(Map<String, dynamic> user) {
    final token = 'tok-${user['id']}-${_random.nextInt(999999)}';
    _tokens[token] = user['id'] as String;
    return {'token': token, 'user': _publicUser(user)};
  }

  Map<String, dynamic>? _userFromAuth(RequestOptions options) {
    final header = options.headers['Authorization'] as String?;
    if (header == null || !header.startsWith('Bearer ')) {
      return null;
    }
    final token = header.substring(7);
    final userId = _tokens[token];
    if (userId == null) {
      return null;
    }
    return _users.cast<Map<String, dynamic>?>().firstWhere(
      (user) => user!['id'] == userId,
      orElse: () => null,
    );
  }

  Map<String, dynamic> _publicUser(Map<String, dynamic> user) {
    return {'id': user['id'], 'name': user['name'], 'email': user['email']};
  }

  List<Map<String, dynamic>> _projectsWithCounts() {
    return _projects.map(_withCounts).toList(growable: false);
  }

  Map<String, dynamic> _withCounts(Map<String, dynamic> project) {
    final related = _tasks
        .where((task) => task['projectId'] == project['id'])
        .toList();
    return {
      ...project,
      'taskCount': related.length,
      'completedTaskCount': related
          .where((task) => task['status'] == 'done')
          .length,
    };
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

  Future<void> _loadUsers() async {
    final raw = await _preferences.getString(StorageKeys.mockUsers);
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _users
          ..clear()
          ..addAll(
            decoded.map((item) => Map<String, dynamic>.from(item as Map)),
          );
      }
    }
    if (_users.isEmpty) {
      _users.add({
        'id': 'u-jane',
        'name': 'Jane Cooper',
        'email': AppConstants.demoEmail,
        'password': AppConstants.demoPassword,
      });
      await _persistUsers();
    }
  }

  Future<void> _persistUsers() async {
    await _preferences.setString(StorageKeys.mockUsers, jsonEncode(_users));
  }

  void _seedProjects() {
    _projects.addAll([
      {
        'id': 'p-1',
        'name': 'Mobile App Redesign',
        'description':
            'Refresh TaskFlow’s mobile experience with a calmer SaaS visual system.',
        'updatedAt': '2026-09-12T09:00:00Z',
      },
      {
        'id': 'p-2',
        'name': 'API Platform',
        'description':
            'Stabilize public APIs, pagination contracts, and error envelopes.',
        'updatedAt': '2026-09-10T14:30:00Z',
      },
      {
        'id': 'p-3',
        'name': 'Marketing Site',
        'description':
            'Launch the product narrative, pricing, and customer stories.',
        'updatedAt': '2026-09-08T11:15:00Z',
      },
      {
        'id': 'p-4',
        'name': 'Internal Tools',
        'description':
            'Admin dashboards for support, billing exceptions, and audit logs.',
        'updatedAt': '2026-09-05T16:45:00Z',
      },
    ]);
  }

  void _seedTasks() {
    const titles = [
      'Audit navigation information architecture',
      'Design empty and error states',
      'Implement project list skeletons',
      'Wire auth redirect on cold start',
      'Document deep-link fallbacks',
      'Add pagination retry affordance',
      'Map Dio exceptions to failures',
      'Cover login Cubit with bloc_test',
      'Write widget test for task form',
      'Tighten analyzer rules',
      'Review token storage lifecycle',
      'Seed realistic fixture data',
      'Polish dark-theme contrast',
      'Extract reusable TaskCard',
      'Add query-parameter filters',
      'Handle 404 unknown routes',
      'Cache last successful project list',
      'Prepare Crashlytics no-op adapter',
      'Define environment dart-defines',
      'Draft architecture decision records',
      'Set up GitHub Actions format check',
      'Create issue templates',
      'Validate register password rules',
      'Support pull-to-refresh on tasks',
      'Prevent duplicate load-more calls',
      'Show end-of-list copy',
      'Add status change shortcuts',
      'Persist theme preference',
      'Build profile notification inbox',
      'Align card spacing to 8pt grid',
      'Write repository failure mapping tests',
      'Add unknown project deep-link handling',
      'Review constructor injection at routes',
      'Ensure splash waits for session restore',
      'Ship README engineering decisions',
    ];

    final now = DateTime.utc(2026, 9, 14, 12);
    for (var i = 0; i < titles.length; i++) {
      final projectId = 'p-${(i % 4) + 1}';
      final status = switch (i % 5) {
        0 => 'done',
        1 => 'inProgress',
        _ => 'todo',
      };
      final priority = switch (i % 3) {
        0 => 'high',
        1 => 'medium',
        _ => 'low',
      };
      final updated = now.subtract(Duration(hours: i * 3));
      _tasks.add({
        'id': 't-${i + 1}',
        'projectId': projectId,
        'title': titles[i],
        'description':
            'Implementation notes for "${titles[i]}" across design, data, and QA.',
        'status': status,
        'priority': priority,
        'dueDate': updated.add(const Duration(days: 5)).toIso8601String(),
        'createdAt': updated
            .subtract(const Duration(days: 2))
            .toIso8601String(),
        'updatedAt': updated.toIso8601String(),
      });
    }
  }

  void _seedNotifications() {
    _notifications.addAll([
      {
        'id': 'n-1',
        'title': 'Welcome to TaskFlow',
        'body': 'Your workspace is ready. Open a project to start planning.',
        'createdAt': '2026-09-14T08:00:00Z',
        'read': false,
        'taskId': null,
      },
      {
        'id': 'n-2',
        'title': 'Task completed',
        'body': 'Tighten analyzer rules was marked as done.',
        'createdAt': '2026-09-13T18:20:00Z',
        'read': true,
        'taskId': 't-10',
      },
      {
        'id': 'n-3',
        'title': 'Deep link ready',
        'body': 'Try taskflow://projects/p-1 from a notes app.',
        'createdAt': '2026-09-12T10:05:00Z',
        'read': false,
        'taskId': 't-5',
      },
    ]);
  }
}
