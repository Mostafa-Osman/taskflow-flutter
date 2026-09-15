import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';

part 'task_form_state.freezed.dart';

@freezed
abstract class TaskFormState with _$TaskFormState {
  const factory TaskFormState({
    String? id,
    @Default('') String title,
    @Default('') String description,
    String? projectId,
    @Default(TaskStatus.todo) TaskStatus status,
    @Default(TaskPriority.medium) TaskPriority priority,
    DateTime? dueDate,
    @Default(false) bool submitting,
    @Default(false) bool submitted,
    String? titleError,
    String? projectError,
    Failure? failure,
  }) = _TaskFormState;

  const TaskFormState._();

  bool get isEditing => id != null;
}
