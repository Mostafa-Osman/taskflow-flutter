import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter.dart';

part 'tasks_state.freezed.dart';

@freezed
sealed class TasksState with _$TasksState {
  const factory TasksState.initial() = TasksInitial;
  const factory TasksState.loading({@Default(TaskFilter()) TaskFilter filter}) =
      TasksLoading;
  const factory TasksState.empty({@Default(TaskFilter()) TaskFilter filter}) =
      TasksEmpty;
  const factory TasksState.error(
    Failure failure, {
    @Default(TaskFilter()) TaskFilter filter,
  }) = TasksError;
  const factory TasksState.success({
    required List<Task> items,
    required TaskFilter filter,
    required bool hasMore,
    @Default(false) bool refreshing,
    @Default(false) bool loadingMore,
    Failure? loadMoreFailure,
  }) = TasksSuccess;
}
