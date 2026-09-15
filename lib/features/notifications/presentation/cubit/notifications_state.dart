import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_notification.dart';

part 'notifications_state.freezed.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = NotificationsInitial;
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.empty() = NotificationsEmpty;
  const factory NotificationsState.success(List<AppNotification> items) =
      NotificationsSuccess;
  const factory NotificationsState.error(Failure failure) = NotificationsError;
}
