import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/result/result.dart';
import 'package:taskflow/core/utils/paged_list.dart';
import 'package:taskflow/features/tasks/domain/entities/task.dart';
import 'package:taskflow/features/tasks/domain/entities/task_filter.dart';
import 'package:taskflow/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:taskflow/features/tasks/presentation/cubit/tasks_state.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockGetTasksUseCase getTasks;

  setUpAll(registerFallbackValues);

  setUp(() {
    getTasks = MockGetTasksUseCase();
  });

  TasksCubit build() => TasksCubit(getTasks);

  blocTest<TasksCubit, TasksState>(
    'load emits empty when the first page has no items',
    build: () {
      when(
        () => getTasks(any()),
      ).thenAnswer((_) async => Success(PagedList<Task>.empty()));
      return build();
    },
    act: (cubit) => cubit.load(),
    expect: () => const [TasksState.loading(), TasksState.empty()],
  );

  blocTest<TasksCubit, TasksState>(
    'load emits success then loadMore appends the next page',
    build: () {
      when(() => getTasks(any())).thenAnswer((invocation) async {
        final params = invocation.positionalArguments.first as GetTasksParams;
        if (params.page == 1) {
          return Success(pagedTasks([demoTask], hasMore: true));
        }
        return Success(
          PagedList<Task>(
            items: [demoTask.copyWith(title: 'Second page')],
            page: 2,
            pageSize: 10,
            total: 2,
            hasMore: false,
          ),
        );
      });
      return build();
    },
    act: (cubit) async {
      await cubit.load();
      await cubit.loadMore();
    },
    expect: () => [
      const TasksState.loading(),
      TasksState.success(
        items: [demoTask],
        filter: const TaskFilter(),
        hasMore: true,
      ),
      TasksState.success(
        items: [demoTask],
        filter: const TaskFilter(),
        hasMore: true,
        loadingMore: true,
      ),
      TasksState.success(
        items: [
          demoTask,
          demoTask.copyWith(title: 'Second page'),
        ],
        filter: const TaskFilter(),
        hasMore: false,
      ),
    ],
  );

  blocTest<TasksCubit, TasksState>(
    'load emits error and retry recovers',
    build: () {
      var attempts = 0;
      when(() => getTasks(any())).thenAnswer((_) async {
        attempts += 1;
        if (attempts == 1) {
          return const Err(NetworkFailure());
        }
        return Success(pagedTasks([demoTask]));
      });
      return build();
    },
    act: (cubit) async {
      await cubit.load();
      await cubit.retry();
    },
    expect: () => [
      const TasksState.loading(),
      const TasksState.error(NetworkFailure()),
      const TasksState.loading(),
      TasksState.success(
        items: [demoTask],
        filter: const TaskFilter(),
        hasMore: false,
      ),
    ],
  );

  blocTest<TasksCubit, TasksState>(
    'loadMore failure keeps existing items',
    build: () {
      when(() => getTasks(any())).thenAnswer((invocation) async {
        final params = invocation.positionalArguments.first as GetTasksParams;
        if (params.page == 1) {
          return Success(pagedTasks([demoTask], hasMore: true));
        }
        return const Err(ServerFailure('page two failed'));
      });
      return build();
    },
    act: (cubit) async {
      await cubit.load();
      await cubit.loadMore();
    },
    expect: () => [
      const TasksState.loading(),
      TasksState.success(
        items: [demoTask],
        filter: const TaskFilter(),
        hasMore: true,
      ),
      TasksState.success(
        items: [demoTask],
        filter: const TaskFilter(),
        hasMore: true,
        loadingMore: true,
      ),
      TasksState.success(
        items: [demoTask],
        filter: const TaskFilter(),
        hasMore: true,
        loadMoreFailure: const ServerFailure('page two failed'),
      ),
    ],
  );
}
