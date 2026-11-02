import '../../../../core/errors/failures.dart';
import '../../../coursework/domain/entities/coursework_item.dart';
import '../../domain/entities/school_class.dart';

sealed class ClassDetailsState {
  const ClassDetailsState();
}

class ClassDetailsInitial extends ClassDetailsState {
  const ClassDetailsInitial();
}

class ClassDetailsLoading extends ClassDetailsState {
  const ClassDetailsLoading();
}

class ClassDetailsError extends ClassDetailsState {
  const ClassDetailsError(this.failure);

  final Failure failure;
}

class ClassDetailsSuccess extends ClassDetailsState {
  const ClassDetailsSuccess({
    required this.schoolClass,
    this.coursework = const [],
    this.busy = false,
    this.message,
  });

  final SchoolClass schoolClass;
  final List<CourseworkItem> coursework;
  final bool busy;
  final String? message;
}
