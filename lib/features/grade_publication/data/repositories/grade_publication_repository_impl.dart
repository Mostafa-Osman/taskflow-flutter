import '../../../../core/network/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../coursework/data/datasources/coursework_remote_data_source.dart';
import '../../../coursework/domain/entities/coursework_item.dart';
import '../../domain/entities/publication_models.dart';
import '../../domain/repositories/grade_publication_repository.dart';
import '../datasources/grade_publication_remote_data_source.dart';

class GradePublicationRepositoryImpl implements GradePublicationRepository {
  GradePublicationRepositoryImpl(this._remote, this._coursework);

  final GradePublicationRemoteDataSource _remote;
  final CourseworkRemoteDataSource _coursework;

  @override
  Future<Result<List<PublicationPreviewItem>>> preview(
    String courseworkId,
  ) async {
    try {
      return Success(await _remote.preview(courseworkId));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<List<PublicationAttempt>>> publish(
    List<String> resultIds,
  ) async {
    try {
      return Success(await _remote.publish(resultIds));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<PublicationAttempt>> retry(String attemptId) async {
    try {
      return Success(await _remote.retry(attemptId));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<CourseworkItem>> approve(String resultId) async {
    try {
      final payload = await _remote.approve(resultId);
      final result = payload['result'] as Map<String, dynamic>;
      return Success(await _coursework.getById(result['courseworkId'] as String).then((dto) => dto.toEntity()));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }
}
