import '../../../../core/classroom/enums.dart';
import '../../../../core/result/result.dart';
import '../entities/coursework_item.dart';

abstract class CourseworkRepository {
  Future<Result<List<CourseworkItem>>> getForClass(String classId);

  Future<Result<CourseworkItem>> getById(String id);

  Future<Result<CourseworkPolicy>> updatePolicy({
    required String courseworkId,
    required CourseworkGradeSyncPolicy policy,
  });
}
