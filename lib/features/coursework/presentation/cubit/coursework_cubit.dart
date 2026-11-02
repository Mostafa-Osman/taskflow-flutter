import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/classroom/enums.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/coursework_item.dart';
import '../../domain/usecases/coursework_usecases.dart';

class CourseworkState {
  const CourseworkState({
    this.item,
    this.loading = false,
    this.busy = false,
    this.failure,
  });

  final CourseworkItem? item;
  final bool loading;
  final bool busy;
  final Failure? failure;
}

class CourseworkCubit extends Cubit<CourseworkState> {
  CourseworkCubit({
    required GetCourseworkUseCase getCoursework,
    required UpdateCourseworkPolicyUseCase updatePolicy,
  }) : _getCoursework = getCoursework,
       _updatePolicy = updatePolicy,
       super(const CourseworkState());

  final GetCourseworkUseCase _getCoursework;
  final UpdateCourseworkPolicyUseCase _updatePolicy;
  String? _id;

  Future<void> load(String id) async {
    _id = id;
    emit(const CourseworkState(loading: true));
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
    final result = await _getCoursework(id);
    result.fold(
      (failure) => emit(CourseworkState(failure: failure)),
      (item) => emit(CourseworkState(item: item)),
    );
  }

  Future<void> updatePolicy(CourseworkGradeSyncPolicy policy) async {
    final item = state.item;
    if (item == null) {
      return;
    }
    emit(CourseworkState(item: item, busy: true));
    final result = await _updatePolicy(
      courseworkId: item.id,
      policy: policy,
    );
    await result.fold(
      (failure) async => emit(CourseworkState(item: item, failure: failure)),
      (_) => load(item.id),
    );
  }
}
