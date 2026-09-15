import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/result/result.dart';
import 'package:taskflow/features/auth/domain/usecases/login_usecase.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  test('rejects invalid credentials before hitting the repository', () async {
    final result = await useCase(email: 'bad', password: '123');
    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  test('delegates valid credentials to the repository', () async {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Success(demoSession));

    final result = await useCase(
      email: ' jane@taskflow.dev ',
      password: 'password123',
    );

    expect(result.valueOrNull, demoSession);
    verify(
      () =>
          repository.login(email: 'jane@taskflow.dev', password: 'password123'),
    ).called(1);
  });
}
