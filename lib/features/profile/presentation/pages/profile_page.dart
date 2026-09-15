import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/env/app_env.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../cubit/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final env = context.read<AppEnv>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final user = switch (state) {
                AuthAuthenticated(:final session) => session.user,
                _ => null,
              };
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user?.name ?? 'Guest'),
                  subtitle: Text(user?.email ?? ''),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('System')),
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ],
                selected: {mode},
                onSelectionChanged: (value) {
                  unawaited(context.read<ThemeCubit>().setMode(value.first));
                },
              );
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Environment'),
            subtitle: Text(env.label),
            trailing: Chip(label: Text(env.name.name.toUpperCase())),
          ),
          const SizedBox(height: 8),
          Text('Notifications', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const _NotificationsPanel(),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => unawaited(context.read<AuthCubit>().logout()),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _NotificationsPanel extends StatelessWidget {
  const _NotificationsPanel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return switch (state) {
          NotificationsInitial() || NotificationsLoading() => const SizedBox(
            height: 120,
            child: AppLoader(),
          ),
          NotificationsEmpty() => const AppEmptyView(
            title: 'No notifications',
            message: 'Activity from your workspace will show up here.',
          ),
          NotificationsError(:final failure) => AppErrorView(
            message: failure.message,
            onRetry: () => context.read<NotificationsCubit>().load(),
          ),
          NotificationsSuccess(:final items) => Column(
            children: items
                .map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(item.title),
                      subtitle: Text(
                        '${item.body}\n${DateFormat.MMMd().add_jm().format(item.createdAt.toLocal())}',
                      ),
                      isThreeLine: true,
                      trailing: item.read
                          ? const Icon(Icons.mark_email_read_outlined)
                          : const Icon(Icons.circle, size: 10),
                      onTap: () {
                        if (!item.read) {
                          unawaited(
                            context.read<NotificationsCubit>().markRead(
                              item.id,
                            ),
                          );
                        }
                        if (item.taskId != null) {
                          unawaited(context.push('/tasks/${item.taskId}'));
                        }
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        };
      },
    );
  }
}
