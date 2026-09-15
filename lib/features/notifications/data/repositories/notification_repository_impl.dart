import '../../../../core/network/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remote);

  final NotificationRemoteDataSource _remote;

  @override
  Future<Result<List<AppNotification>>> getNotifications() async {
    try {
      final dtos = await _remote.getNotifications();
      return Success(dtos.map((dto) => dto.toEntity()).toList(growable: false));
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<AppNotification>> markRead(String id) async {
    try {
      final dto = await _remote.markRead(id);
      return Success(dto.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }
}
