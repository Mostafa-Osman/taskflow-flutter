import '../../../../core/result/result.dart';
import '../entities/school_class.dart';
import '../repositories/class_repository.dart';

class GetClassDetailsUseCase {
  const GetClassDetailsUseCase(this._repository);

  final ClassRepository _repository;

  Future<Result<SchoolClass>> call(String id) => _repository.getClass(id);
}
