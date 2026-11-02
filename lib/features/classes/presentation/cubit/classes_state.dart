import '../../../../core/errors/failures.dart';
import '../../domain/entities/class_filter.dart';
import '../../domain/entities/school_class.dart';

sealed class ClassesState {
  const ClassesState();
}

class ClassesInitial extends ClassesState {
  const ClassesInitial();
}

class ClassesLoading extends ClassesState {
  const ClassesLoading({this.filter = const ClassFilter()});

  final ClassFilter filter;
}

class ClassesEmpty extends ClassesState {
  const ClassesEmpty({this.filter = const ClassFilter()});

  final ClassFilter filter;
}

class ClassesError extends ClassesState {
  const ClassesError(this.failure, {this.filter = const ClassFilter()});

  final Failure failure;
  final ClassFilter filter;
}

class ClassesSuccess extends ClassesState {
  const ClassesSuccess({
    required this.items,
    required this.filter,
    this.refreshing = false,
  });

  final List<SchoolClass> items;
  final ClassFilter filter;
  final bool refreshing;
}
