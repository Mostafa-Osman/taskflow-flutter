import '../../../../core/result/result.dart';
import '../entities/app_notification.dart';

abstract class NotificationRepository {
  Future<Result<List<AppNotification>>> getNotifications();

  Future<Result<AppNotification>> markRead(String id);
}
