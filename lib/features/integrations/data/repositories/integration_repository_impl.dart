import '../../../../core/classroom/enums.dart';
import '../../../../core/network/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../classes/domain/entities/school_class.dart';
import '../../domain/entities/google_connection.dart';
import '../../domain/repositories/integration_repository.dart';
import '../datasources/integration_remote_data_source.dart';

class IntegrationRepositoryImpl implements IntegrationRepository {
  IntegrationRepositoryImpl(this._remote);

  final IntegrationRemoteDataSource _remote;

  @override
  Future<Result<GoogleConnection>> connect() async {
    try {
      return Success(_toConnection(await _remote.connect()));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<GoogleConnection>> disconnect() async {
    try {
      return Success(_toConnection(await _remote.disconnect()));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<GoogleConnection>> getSettings() async {
    try {
      return Success(_toConnection(await _remote.getSettings()));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<GoogleConnection>> updatePolicy(
    ConnectionGradeSyncPolicy policy,
  ) async {
    try {
      return Success(_toConnection(await _remote.updatePolicy(policy)));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<List<ExternalCourseOption>>> listCourses() async {
    try {
      return Success(await _remote.listCourses());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<List<SchoolClass>>> importCourses(List<String> courseIds) async {
    try {
      final items = await _remote.importCourses(courseIds);
      return Success(items.map((item) => item.toEntity()).toList());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  GoogleConnection _toConnection(Map<String, dynamic> json) {
    return GoogleConnection(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      ownerTeacherId: json['ownerTeacherId'] as String,
      status: ConnectionStatus.fromApi(json['status'] as String?),
      gradeSyncPolicy: ConnectionGradeSyncPolicy.fromApi(
        json['gradeSyncPolicy'] as String?,
      ),
      capabilityState: CapabilityState.fromApi(
        json['capabilityState'] as String?,
      ),
      checkedAt: json['checkedAt'] == null
          ? null
          : DateTime.tryParse(json['checkedAt'] as String),
      lastErrorMessage: json['lastErrorMessage'] as String?,
    );
  }
}
