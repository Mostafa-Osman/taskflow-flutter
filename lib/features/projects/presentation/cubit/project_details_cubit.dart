import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_project_details_usecase.dart';
import 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  ProjectDetailsCubit(this._getProject)
    : super(const ProjectDetailsState.initial());

  final GetProjectDetailsUseCase _getProject;
  String? _id;

  Future<void> load(String id) async {
    _id = id;
    emit(const ProjectDetailsState.loading());
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
    final result = await _getProject(id);
    result.fold(
      (failure) => emit(ProjectDetailsState.error(failure)),
      (project) => emit(ProjectDetailsState.success(project)),
    );
  }
}
