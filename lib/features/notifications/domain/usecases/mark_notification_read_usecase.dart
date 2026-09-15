import '../../../../core/result/result.dart';
import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<AppNotification>> call(String id) => _repository.markRead(id);
}
