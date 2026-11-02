import '../../../../core/result/result.dart';
import '../entities/school_class.dart';
import '../repositories/class_repository.dart';

class MapClassUseCase {
  const MapClassUseCase(this._repository);

  final ClassRepository _repository;

  Future<Result<SchoolClass>> call({
    required String classId,
    required String externalCourseId,
    required bool confirmed,
  }) {
    return _repository.mapClass(
      classId: classId,
      externalCourseId: externalCourseId,
      confirmed: confirmed,
    );
  }
}

class UnmapClassUseCase {
  const UnmapClassUseCase(this._repository);

  final ClassRepository _repository;

  Future<Result<SchoolClass>> call({
    required String classId,
    required String mappingId,
  }) {
    return _repository.unmapClass(classId: classId, mappingId: mappingId);
  }
}

class SyncClassUseCase {
  const SyncClassUseCase(this._repository);

  final ClassRepository _repository;

  Future<Result<SchoolClass>> call(String classId) {
    return _repository.syncClass(classId);
  }
}
