import '../../../../core/classroom/enums.dart';
import '../../../../core/result/result.dart';
import '../entities/coursework_item.dart';
import '../repositories/coursework_repository.dart';

class GetCourseworkUseCase {
  const GetCourseworkUseCase(this._repository);

  final CourseworkRepository _repository;

  Future<Result<CourseworkItem>> call(String id) => _repository.getById(id);
}

class UpdateCourseworkPolicyUseCase {
  const UpdateCourseworkPolicyUseCase(this._repository);

  final CourseworkRepository _repository;

  Future<Result<CourseworkPolicy>> call({
    required String courseworkId,
    required CourseworkGradeSyncPolicy policy,
  }) {
    return _repository.updatePolicy(
      courseworkId: courseworkId,
      policy: policy,
    );
  }
}
