import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task_status.dart';
import '../../domain/usecases/change_task_status_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_task_details_usecase.dart';
import 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  TaskDetailsCubit({
    required GetTaskDetailsUseCase getTask,
    required ChangeTaskStatusUseCase changeStatus,
    required DeleteTaskUseCase deleteTask,
  }) : _getTask = getTask,
       _changeStatus = changeStatus,
       _deleteTask = deleteTask,
       super(const TaskDetailsState.initial());

  final GetTaskDetailsUseCase _getTask;
  final ChangeTaskStatusUseCase _changeStatus;
  final DeleteTaskUseCase _deleteTask;
  String? _id;

  Future<void> load(String id) async {
    _id = id;
    emit(const TaskDetailsState.loading());
    await _fetch(id);
  }

  Future<void> refresh() async {
    final id = _id;
    if (id == null) {
      return;
    }
    await _fetch(id);
  }

  Future<void> _fetch(String id) async {
    final result = await _getTask(id);
    result.fold(
      (failure) => emit(TaskDetailsState.error(failure)),
      (task) => emit(TaskDetailsState.success(task)),
    );
  }

  Future<void> markDone() async {
    final current = state;
    if (current is! TaskDetailsSuccess) {
      return;
    }
    emit(current.copyWith(busy: true));
    final result = await _changeStatus(
      id: current.task.id,
      status: TaskStatus.done,
    );
    result.fold(
      (failure) => emit(TaskDetailsState.error(failure)),
      (task) => emit(TaskDetailsState.success(task)),
    );
  }

  Future<void> changeStatus(TaskStatus status) async {
    final current = state;
    if (current is! TaskDetailsSuccess) {
      return;
    }
    emit(current.copyWith(busy: true));
    final result = await _changeStatus(id: current.task.id, status: status);
    result.fold(
      (failure) => emit(TaskDetailsState.error(failure)),
      (task) => emit(TaskDetailsState.success(task)),
    );
  }

  Future<void> delete() async {
    final current = state;
    if (current is! TaskDetailsSuccess) {
      return;
    }
    emit(current.copyWith(busy: true));
    final result = await _deleteTask(current.task.id);
    result.fold(
      (failure) => emit(TaskDetailsState.error(failure)),
      (_) => emit(const TaskDetailsState.deleted()),
    );
  }
}
