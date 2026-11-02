import '../../../../core/result/result.dart';
import '../entities/coursework_item.dart';
import '../repositories/coursework_repository.dart';

class GetClassCourseworkUseCase {
  const GetClassCourseworkUseCase(this._repository);

  final CourseworkRepository _repository;

  Future<Result<List<CourseworkItem>>> call(String classId) {
    return _repository.getForClass(classId);
  }
}
