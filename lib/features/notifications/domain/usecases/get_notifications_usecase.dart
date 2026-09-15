import '../../../../core/result/result.dart';
import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<List<AppNotification>>> call() =>
      _repository.getNotifications();
}
