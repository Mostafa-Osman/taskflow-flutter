import '../../../../core/result/result.dart';
import '../entities/class_filter.dart';
import '../entities/school_class.dart';
import '../repositories/class_repository.dart';

class GetClassesUseCase {
  const GetClassesUseCase(this._repository);

  final ClassRepository _repository;

  Future<Result<List<SchoolClass>>> call(ClassFilter filter) {
    return _repository.getClasses(filter);
  }
}
