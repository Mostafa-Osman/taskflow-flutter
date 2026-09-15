import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/project.dart';

part 'projects_state.freezed.dart';

@freezed
sealed class ProjectsState with _$ProjectsState {
  const factory ProjectsState.initial() = ProjectsInitial;
  const factory ProjectsState.loading() = ProjectsLoading;
  const factory ProjectsState.empty() = ProjectsEmpty;
  const factory ProjectsState.success({
    required List<Project> projects,
    @Default(false) bool refreshing,
  }) = ProjectsSuccess;
  const factory ProjectsState.error(Failure failure) = ProjectsError;
}
