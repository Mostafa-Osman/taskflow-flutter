import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_projects_usecase.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit(this._getProjects) : super(const ProjectsState.initial());

  final GetProjectsUseCase _getProjects;

  Future<void> load() async {
    emit(const ProjectsState.loading());
    await _fetch();
  }

  Future<void> refresh() async {
    final current = state;
    if (current is ProjectsSuccess) {
      emit(current.copyWith(refreshing: true));
    }
    await _fetch();
  }

  Future<void> retry() => load();

  Future<void> _fetch() async {
    final result = await _getProjects();
    result.fold((failure) => emit(ProjectsState.error(failure)), (projects) {
      if (projects.isEmpty) {
        emit(const ProjectsState.empty());
        return;
      }
      emit(ProjectsState.success(projects: projects));
    });
  }
}
