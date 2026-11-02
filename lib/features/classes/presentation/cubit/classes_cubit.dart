import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/class_filter.dart';
import '../../domain/usecases/get_classes_usecase.dart';
import 'classes_state.dart';

class ClassesCubit extends Cubit<ClassesState> {
  ClassesCubit(this._getClasses) : super(const ClassesInitial());

  final GetClassesUseCase _getClasses;
  ClassFilter _filter = const ClassFilter();

  Future<void> load({ClassFilter? filter}) async {
    if (filter != null) {
      _filter = filter;
    }
    emit(ClassesLoading(filter: _filter));
    await _fetch();
  }

  Future<void> applyFilter(ClassFilter filter) => load(filter: filter);

  Future<void> retry() => load(filter: _filter);

  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    final result = await _getClasses(_filter);
    result.fold(
      (failure) => emit(ClassesError(failure, filter: _filter)),
      (items) {
        if (items.isEmpty) {
          emit(ClassesEmpty(filter: _filter));
          return;
        }
        emit(ClassesSuccess(items: items, filter: _filter));
      },
    );
  }
}
