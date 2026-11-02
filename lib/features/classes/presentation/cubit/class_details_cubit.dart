import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../coursework/domain/usecases/get_class_coursework_usecase.dart';
import '../../domain/usecases/class_mapping_usecases.dart';
import '../../domain/usecases/get_class_details_usecase.dart';
import 'class_details_state.dart';

class ClassDetailsCubit extends Cubit<ClassDetailsState> {
  ClassDetailsCubit({
    required GetClassDetailsUseCase getClass,
    required GetClassCourseworkUseCase getCoursework,
    required MapClassUseCase mapClass,
    required UnmapClassUseCase unmapClass,
    required SyncClassUseCase syncClass,
  }) : _getClass = getClass,
       _getCoursework = getCoursework,
       _mapClass = mapClass,
       _unmapClass = unmapClass,
       _syncClass = syncClass,
       super(const ClassDetailsInitial());

  final GetClassDetailsUseCase _getClass;
  final GetClassCourseworkUseCase _getCoursework;
  final MapClassUseCase _mapClass;
  final UnmapClassUseCase _unmapClass;
  final SyncClassUseCase _syncClass;
  String? _id;

  Future<void> load(String id) async {
    _id = id;
    emit(const ClassDetailsLoading());
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
    final result = await _getClass(id);
    await result.fold((failure) async => emit(ClassDetailsError(failure)), (
      schoolClass,
    ) async {
      final work = await _getCoursework(id);
      emit(
        ClassDetailsSuccess(
          schoolClass: schoolClass,
          coursework: work.valueOrNull ?? const [],
        ),
      );
    });
  }

  Future<void> mapExisting(String externalCourseId) async {
    final id = _id;
    if (id == null) {
      return;
    }
    emit(_busy());
    final result = await _mapClass(
      classId: id,
      externalCourseId: externalCourseId,
      confirmed: true,
    );
    await result.fold((failure) async => emit(ClassDetailsError(failure)), (
      _,
    ) => load(id));
  }

  Future<void> unmap() async {
    final current = state;
    if (current is! ClassDetailsSuccess || current.schoolClass.mapping == null) {
      return;
    }
    emit(_busy());
    final result = await _unmapClass(
      classId: current.schoolClass.id,
      mappingId: current.schoolClass.mapping!.id,
    );
    await result.fold((failure) async => emit(ClassDetailsError(failure)), (
      _,
    ) => load(current.schoolClass.id));
  }

  Future<void> sync() async {
    final id = _id;
    if (id == null) {
      return;
    }
    emit(_busy());
    final result = await _syncClass(id);
    await result.fold((failure) async => emit(ClassDetailsError(failure)), (
      _,
    ) => load(id));
  }

  ClassDetailsState _busy() {
    final current = state;
    if (current is ClassDetailsSuccess) {
      return ClassDetailsSuccess(
        schoolClass: current.schoolClass,
        coursework: current.coursework,
        busy: true,
      );
    }
    return const ClassDetailsLoading();
  }
}
