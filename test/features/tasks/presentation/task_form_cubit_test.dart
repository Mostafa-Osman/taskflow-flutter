import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/result/result.dart';
import 'package:taskflow/features/tasks/presentation/cubit/task_form_cubit.dart';
import 'package:taskflow/features/tasks/presentation/cubit/task_form_state.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockCreateTaskUseCase createTask;
  late MockUpdateTaskUseCase updateTask;

  setUpAll(registerFallbackValues);

  setUp(() {
    createTask = MockCreateTaskUseCase();
    updateTask = MockUpdateTaskUseCase();
  });

  TaskFormCubit build() {
    return TaskFormCubit(createTask: createTask, updateTask: updateTask);
  }

  blocTest<TaskFormCubit, TaskFormState>(
    'submit surfaces field errors without calling use cases',
    build: build,
    act: (cubit) => cubit.submit(),
    expect: () => [
      isA<TaskFormState>()
          .having((state) => state.titleError, 'titleError', isNotNull)
          .having((state) => state.projectError, 'projectError', isNotNull),
    ],
    verify: (_) {
      verifyNever(() => createTask(any()));
    },
  );

  blocTest<TaskFormCubit, TaskFormState>(
    'submit creates a task when the form is valid',
    build: () {
      when(() => createTask(any())).thenAnswer((_) async => Success(demoTask));
      return build();
    },
    act: (cubit) async {
      cubit
        ..setTitle('Design empty states')
        ..setProjectId('p-1');
      await cubit.submit();
    },
    expect: () => [
      isA<TaskFormState>().having(
        (state) => state.title,
        'title',
        'Design empty states',
      ),
      isA<TaskFormState>().having(
        (state) => state.projectId,
        'projectId',
        'p-1',
      ),
      isA<TaskFormState>().having(
        (state) => state.submitting,
        'submitting',
        true,
      ),
      isA<TaskFormState>().having(
        (state) => state.submitted,
        'submitted',
        true,
      ),
    ],
  );
}
