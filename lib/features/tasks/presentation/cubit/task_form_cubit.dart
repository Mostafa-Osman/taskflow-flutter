import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import 'task_form_state.dart';

class TaskFormCubit extends Cubit<TaskFormState> {
  TaskFormCubit({
    required CreateTaskUseCase createTask,
    required UpdateTaskUseCase updateTask,
  }) : _createTask = createTask,
       _updateTask = updateTask,
       super(const TaskFormState());

  final CreateTaskUseCase _createTask;
  final UpdateTaskUseCase _updateTask;

  void hydrate(Task task) {
    emit(
      TaskFormState(
        id: task.id,
        title: task.title,
        description: task.description,
        projectId: task.projectId,
        status: task.status,
        priority: task.priority,
        dueDate: task.dueDate,
      ),
    );
  }

  void setTitle(String value) =>
      emit(state.copyWith(title: value, titleError: null, failure: null));

  void setDescription(String value) => emit(state.copyWith(description: value));

  void setProjectId(String? value) =>
      emit(state.copyWith(projectId: value, projectError: null));

  void setStatus(TaskStatus status) => emit(state.copyWith(status: status));

  void setPriority(TaskPriority priority) =>
      emit(state.copyWith(priority: priority));

  void setDueDate(DateTime? dueDate) => emit(state.copyWith(dueDate: dueDate));

  Future<void> submit() async {
    final titleError = Validators.required(state.title, field: 'Title');
    final projectError = Validators.required(state.projectId, field: 'Project');
    if (titleError != null || projectError != null) {
      emit(state.copyWith(titleError: titleError, projectError: projectError));
      return;
    }

    emit(state.copyWith(submitting: true, failure: null));
    if (state.isEditing) {
      final result = await _updateTask(
        Task(
          id: state.id!,
          projectId: state.projectId!,
          title: state.title.trim(),
          description: state.description.trim(),
          status: state.status,
          priority: state.priority,
          dueDate: state.dueDate,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      result.fold(
        (failure) => emit(state.copyWith(submitting: false, failure: failure)),
        (_) => emit(state.copyWith(submitting: false, submitted: true)),
      );
      return;
    }

    final result = await _createTask(
      CreateTaskInput(
        projectId: state.projectId!,
        title: state.title.trim(),
        description: state.description.trim(),
        status: state.status,
        priority: state.priority,
        dueDate: state.dueDate,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(submitting: false, failure: failure)),
      (_) => emit(state.copyWith(submitting: false, submitted: true)),
    );
  }
}
