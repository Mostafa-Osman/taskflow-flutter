import '../../../../core/network/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/class_filter.dart';
import '../../domain/entities/school_class.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/class_remote_data_source.dart';

class ClassRepositoryImpl implements ClassRepository {
  ClassRepositoryImpl(this._remote);

  final ClassRemoteDataSource _remote;

  @override
  Future<Result<List<SchoolClass>>> getClasses(ClassFilter filter) async {
    try {
      final items = await _remote.getClasses(filter);
      return Success(items.map((item) => item.toEntity()).toList());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<SchoolClass>> getClass(String id) async {
    try {
      final item = await _remote.getClass(id);
      return Success(item.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<SchoolClass>> createClass(CreateClassInput input) async {
    try {
      final item = await _remote.createClass(input);
      return Success(item.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<SchoolClass>> mapClass({
    required String classId,
    required String externalCourseId,
    required bool confirmed,
  }) async {
    try {
      final item = await _remote.mapClass(
        classId: classId,
        externalCourseId: externalCourseId,
        confirmed: confirmed,
      );
      return Success(item.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<SchoolClass>> unmapClass({
    required String classId,
    required String mappingId,
  }) async {
    try {
      final item = await _remote.unmapClass(
        classId: classId,
        mappingId: mappingId,
      );
      return Success(item.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<SchoolClass>> syncClass(String classId) async {
    try {
      final item = await _remote.syncClass(classId);
      return Success(item.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }
}
