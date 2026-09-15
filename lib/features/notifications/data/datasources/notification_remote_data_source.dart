import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/notification_dto.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationDto>> getNotifications();

  Future<NotificationDto> markRead(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<NotificationDto>> getNotifications() async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.notifications,
    );
    return (response.data ?? const [])
        .map((item) => NotificationDto.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<NotificationDto> markRead(String id) async {
    final response = await _client.patch<Map<String, dynamic>>(
      ApiEndpoints.notificationRead(id),
    );
    return NotificationDto.fromJson(response.data!);
  }
}
