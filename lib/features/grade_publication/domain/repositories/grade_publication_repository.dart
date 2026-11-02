import '../../../../core/result/result.dart';
import '../../../coursework/domain/entities/coursework_item.dart';
import '../entities/publication_models.dart';

abstract class GradePublicationRepository {
  Future<Result<List<PublicationPreviewItem>>> preview(String courseworkId);

  Future<Result<List<PublicationAttempt>>> publish(List<String> resultIds);

  Future<Result<PublicationAttempt>> retry(String attemptId);

  Future<Result<CourseworkItem>> approve(String resultId);
}
