import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/result/result.dart';
import 'package:taskflow/features/tasks/domain/entities/task_priority.dart';
import 'package:taskflow/features/tasks/domain/entities/task_status.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';
import 'package:taskflow/features/tasks/domain/usecases/create_task_usecase.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockTaskRepository repository;
  late CreateTaskUseCase useCase;

  setUpAll(registerFallbackValues);

  setUp(() {
    repository = MockTaskRepository();
    useCase = CreateTaskUseCase(repository);
  });

  test('rejects a missing title', () async {
    final result = await useCase(
      const CreateTaskInput(
        projectId: 'p-1',
        title: '  ',
        description: '',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
      ),
    );
    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(() => repository.createTask(any()));
  });

  test('delegates a valid payload', () async {
    when(
      () => repository.createTask(any()),
    ).thenAnswer((_) async => Success(demoTask));
    final result = await useCase(
      const CreateTaskInput(
        projectId: 'p-1',
        title: 'Design empty states',
        description: '',
        status: TaskStatus.todo,
        priority: TaskPriority.high,
      ),
    );
    expect(result.valueOrNull, demoTask);
  });
}
