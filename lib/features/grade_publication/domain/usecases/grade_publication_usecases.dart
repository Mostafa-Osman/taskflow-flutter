import '../../../../core/result/result.dart';
import '../../../coursework/domain/entities/coursework_item.dart';
import '../entities/publication_models.dart';
import '../repositories/grade_publication_repository.dart';

class PreviewPublicationsUseCase {
  const PreviewPublicationsUseCase(this._repository);

  final GradePublicationRepository _repository;

  Future<Result<List<PublicationPreviewItem>>> call(String courseworkId) {
    return _repository.preview(courseworkId);
  }
}

class PublishGradesUseCase {
  const PublishGradesUseCase(this._repository);

  final GradePublicationRepository _repository;

  Future<Result<List<PublicationAttempt>>> call(List<String> resultIds) {
    return _repository.publish(resultIds);
  }
}

class RetryPublicationUseCase {
  const RetryPublicationUseCase(this._repository);

  final GradePublicationRepository _repository;

  Future<Result<PublicationAttempt>> call(String attemptId) {
    return _repository.retry(attemptId);
  }
}

class ApproveGradeUseCase {
  const ApproveGradeUseCase(this._repository);

  final GradePublicationRepository _repository;

  Future<Result<CourseworkItem>> call(String resultId) {
    return _repository.approve(resultId);
  }
}
