import '../../../../core/classroom/enums.dart';
import '../../../../core/network/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/coursework_item.dart';
import '../../domain/repositories/coursework_repository.dart';
import '../datasources/coursework_remote_data_source.dart';
import '../models/coursework_dto.dart';

class CourseworkRepositoryImpl implements CourseworkRepository {
  CourseworkRepositoryImpl(this._remote);

  final CourseworkRemoteDataSource _remote;

  @override
  Future<Result<List<CourseworkItem>>> getForClass(String classId) async {
    try {
      final items = await _remote.getForClass(classId);
      return Success(items.map((item) => item.toEntity()).toList());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<CourseworkItem>> getById(String id) async {
    try {
      final item = await _remote.getById(id);
      return Success(item.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<CourseworkPolicy>> updatePolicy({
    required String courseworkId,
    required CourseworkGradeSyncPolicy policy,
  }) async {
    try {
      final json = await _remote.updatePolicy(
        courseworkId: courseworkId,
        policy: policy,
      );
      return Success(
        CourseworkDto.fromJson({
          'id': courseworkId,
          'classId': '',
          'title': '',
          'policy': json,
        }).toEntity().policy,
      );
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }
}
