import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/errors/exceptions.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:taskflow/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taskflow/features/auth/data/models/auth_response_dto.dart';
import 'package:taskflow/features/auth/data/models/user_dto.dart';
import 'package:taskflow/features/auth/data/repositories/auth_repository_impl.dart';

class MockRemote extends Mock implements AuthRemoteDataSource {}

class MockLocal extends Mock implements AuthLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late AuthRepositoryImpl repository;

  const user = UserDto(id: 'u-1', name: 'Jane', email: 'jane@taskflow.dev');
  const response = AuthResponseDto(token: 'tok-1', user: user);

  setUpAll(() {
    registerFallbackValue(user);
  });

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = AuthRepositoryImpl(remote: remote, local: local);
  });

  test('login caches the session and returns an entity', () async {
    when(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => response);
    when(
      () => local.cacheSession(
        token: any(named: 'token'),
        user: any(named: 'user'),
      ),
    ).thenAnswer((_) async {});

    final result = await repository.login(
      email: 'jane@taskflow.dev',
      password: 'password123',
    );

    expect(result.valueOrNull?.token, 'tok-1');
    verify(() => local.cacheSession(token: 'tok-1', user: user)).called(1);
  });

  test('login maps unauthorized exceptions to failures', () async {
    when(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const UnauthorizedException('Invalid email or password.'));

    final result = await repository.login(
      email: 'jane@taskflow.dev',
      password: 'wrong',
    );

    expect(result.failureOrNull, isA<UnauthorizedFailure>());
  });

  test('restoreSession returns null when no token is stored', () async {
    when(() => local.readToken()).thenAnswer((_) async => null);
    final result = await repository.restoreSession();
    expect(result.valueOrNull, isNull);
  });
}
