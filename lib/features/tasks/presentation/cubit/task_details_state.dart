import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';

part 'task_details_state.freezed.dart';

@freezed
sealed class TaskDetailsState with _$TaskDetailsState {
  const factory TaskDetailsState.initial() = TaskDetailsInitial;
  const factory TaskDetailsState.loading() = TaskDetailsLoading;
  const factory TaskDetailsState.success(
    Task task, {
    @Default(false) bool busy,
  }) = TaskDetailsSuccess;
  const factory TaskDetailsState.error(Failure failure) = TaskDetailsError;
  const factory TaskDetailsState.deleted() = TaskDetailsDeleted;
}
