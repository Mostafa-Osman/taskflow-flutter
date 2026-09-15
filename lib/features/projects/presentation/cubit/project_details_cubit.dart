import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_project_details_usecase.dart';
import 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  ProjectDetailsCubit(this._getProject)
    : super(const ProjectDetailsState.initial());

  final GetProjectDetailsUseCase _getProject;

  Future<void> load(String id) async {
    emit(const ProjectDetailsState.loading());
    final result = await _getProject(id);
    result.fold(
      (failure) => emit(ProjectDetailsState.error(failure)),
      (project) => emit(ProjectDetailsState.success(project)),
    );
  }
}
