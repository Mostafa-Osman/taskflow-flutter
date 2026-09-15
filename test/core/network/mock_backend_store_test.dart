import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
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

  setUp(() async {
    store = MockBackendStore(preferences: MemoryPreferences());
    await store.initialize();
  });

  test('login succeeds for the seed user', () async {
    final response = await store.handle(
      RequestOptions(
        path: '/auth/login',
        method: 'POST',
        data: {'email': 'jane@taskflow.dev', 'password': 'password123'},
      ),
    );
    expect(response.statusCode, 200);
    expect((response.data as Map<String, dynamic>)['token'], isNotEmpty);
  });

  test('tasks are paginated in pages of ten', () async {
    final response = await store.handle(
      RequestOptions(
        path: '/tasks',
        method: 'GET',
        queryParameters: {'page': 1, 'pageSize': 10},
      ),
    );
    final data = response.data as Map<String, dynamic>;
    expect((data['items'] as List<dynamic>).length, 10);
    expect(data['hasMore'], isTrue);
    expect(data['total'], greaterThan(10));
  });

  test('search filters by title', () async {
    final response = await store.handle(
      RequestOptions(
        path: '/tasks',
        method: 'GET',
        queryParameters: {'query': 'pagination'},
      ),
    );
    final items =
        (response.data as Map<String, dynamic>)['items'] as List<dynamic>;
    expect(items, isNotEmpty);
    expect(
      items.every(
        (item) => (item as Map<String, dynamic>)['title']
            .toString()
            .toLowerCase()
            .contains('pagination'),
      ),
      isTrue,
    );
  });
}
