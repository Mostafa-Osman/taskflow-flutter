import '../../../../core/classroom/enums.dart';
import '../../../../core/result/result.dart';
import '../../../classes/domain/entities/school_class.dart';
import '../entities/google_connection.dart';

abstract class IntegrationRepository {
  Future<Result<GoogleConnection>> connect();

  Future<Result<GoogleConnection>> disconnect();

  Future<Result<GoogleConnection>> getSettings();

  Future<Result<GoogleConnection>> updatePolicy(ConnectionGradeSyncPolicy policy);

  Future<Result<List<ExternalCourseOption>>> listCourses();

  Future<Result<List<SchoolClass>>> importCourses(List<String> courseIds);
}
