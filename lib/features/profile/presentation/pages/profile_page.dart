import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/env/app_env.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../notifications/presentation/cubit/notifications_state.dart';
import '../../domain/app_language.dart';
import '../cubit/locale_cubit.dart';
import '../cubit/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final env = context.read<AppEnv>();
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: RefreshIndicator(
        onRefresh: () => context.read<NotificationsCubit>().refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  title: Text(user?.name ?? l10n.guest),
                  subtitle: Text(user?.email ?? ''),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          BlocBuilder<LocaleCubit, AppLanguage>(
            builder: (context, language) {
              return SegmentedButton<AppLanguage>(
                segments: [
                  ButtonSegment(
                    value: AppLanguage.system,
                    label: Text(l10n.languageSystem),
                  ),
                  ButtonSegment(
                    value: AppLanguage.english,
                    label: Text(l10n.languageEnglish),
                  ),
                  ButtonSegment(
                    value: AppLanguage.arabic,
                    label: Text(l10n.languageArabic),
                  ),
                ],
                selected: {language},
                onSelectionChanged: (value) {
                  unawaited(
                    context.read<LocaleCubit>().setLanguage(value.first),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Text(l10n.appearance, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeSystem),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                  ),
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
            title: Text(l10n.environment),
            subtitle: Text(env.label),
            trailing: Chip(label: Text(env.name.name.toUpperCase())),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.notifications,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const _NotificationsPanel(),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => unawaited(context.read<AuthCubit>().logout()),
            child: Text(l10n.signOut),
          ),
        ],
        ),
      ),
    );
  }
}

class _NotificationsPanel extends StatelessWidget {
  const _NotificationsPanel();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return switch (state) {
          NotificationsInitial() ||
          NotificationsLoading() => const AppSkeleton(shrinkWrap: true),
          NotificationsEmpty() => AppEmptyView(
            title: l10n.noNotifications,
            message: l10n.noNotificationsMessage,
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
                        '${item.body}\n${DateFormat.MMMd(context.localeName).add_jm().format(item.createdAt.toLocal())}',
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
