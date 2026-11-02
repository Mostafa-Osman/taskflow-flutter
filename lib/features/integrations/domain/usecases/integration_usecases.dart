import '../../../../core/classroom/enums.dart';
import '../../../../core/result/result.dart';
import '../../../classes/domain/entities/school_class.dart';
import '../entities/google_connection.dart';
import '../repositories/integration_repository.dart';

class ConnectGoogleClassroomUseCase {
  const ConnectGoogleClassroomUseCase(this._repository);

  final IntegrationRepository _repository;

  Future<Result<GoogleConnection>> call() => _repository.connect();
}

class DisconnectGoogleClassroomUseCase {
  const DisconnectGoogleClassroomUseCase(this._repository);

  final IntegrationRepository _repository;

  Future<Result<GoogleConnection>> call() => _repository.disconnect();
}

class GetIntegrationSettingsUseCase {
  const GetIntegrationSettingsUseCase(this._repository);

  final IntegrationRepository _repository;

  Future<Result<GoogleConnection>> call() => _repository.getSettings();
}

class UpdateConnectionPolicyUseCase {
  const UpdateConnectionPolicyUseCase(this._repository);

  final IntegrationRepository _repository;

  Future<Result<GoogleConnection>> call(ConnectionGradeSyncPolicy policy) {
    return _repository.updatePolicy(policy);
  }
}

class ListExternalCoursesUseCase {
  const ListExternalCoursesUseCase(this._repository);

  final IntegrationRepository _repository;

  Future<Result<List<ExternalCourseOption>>> call() => _repository.listCourses();
}

class ImportExternalCoursesUseCase {
  const ImportExternalCoursesUseCase(this._repository);

  final IntegrationRepository _repository;

  Future<Result<List<SchoolClass>>> call(List<String> courseIds) {
    return _repository.importCourses(courseIds);
  }
}
