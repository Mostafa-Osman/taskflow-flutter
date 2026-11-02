import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required GetNotificationsUseCase getNotifications,
    required MarkNotificationReadUseCase markRead,
  }) : _getNotifications = getNotifications,
       _markRead = markRead,
       super(const NotificationsState.initial());

  final GetNotificationsUseCase _getNotifications;
  final MarkNotificationReadUseCase _markRead;

  Future<void> load() async {
    emit(const NotificationsState.loading());
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    final result = await _getNotifications();
    result.fold((failure) => emit(NotificationsState.error(failure)), (items) {
      if (items.isEmpty) {
        emit(const NotificationsState.empty());
        return;
      }
      emit(NotificationsState.success(items));
    });
  }

  Future<void> markRead(String id) async {
    final result = await _markRead(id);
    result.fold((_) {}, (_) => unawaited(load()));
  }
}
