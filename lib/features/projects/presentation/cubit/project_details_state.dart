import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/project.dart';

part 'project_details_state.freezed.dart';

@freezed
sealed class ProjectDetailsState with _$ProjectDetailsState {
  const factory ProjectDetailsState.initial() = ProjectDetailsInitial;
  const factory ProjectDetailsState.loading() = ProjectDetailsLoading;
  const factory ProjectDetailsState.success(Project project) =
      ProjectDetailsSuccess;
  const factory ProjectDetailsState.error(Failure failure) =
      ProjectDetailsError;
}
