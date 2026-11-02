import '../../../../core/result/result.dart';
import '../entities/class_filter.dart';
import '../entities/school_class.dart';

abstract class ClassRepository {
  Future<Result<List<SchoolClass>>> getClasses(ClassFilter filter);

  Future<Result<SchoolClass>> getClass(String id);

  Future<Result<SchoolClass>> createClass(CreateClassInput input);

  Future<Result<SchoolClass>> mapClass({
    required String classId,
    required String externalCourseId,
    required bool confirmed,
  });

  Future<Result<SchoolClass>> unmapClass({
    required String classId,
    required String mappingId,
  });

  Future<Result<SchoolClass>> syncClass(String classId);
}
