import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/label_localizations.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_refreshable.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';
import '../cubit/task_details_cubit.dart';
import '../cubit/task_details_state.dart';
import '../widgets/task_card.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskDetailsCubit, TaskDetailsState>(
      listenWhen: (previous, current) => current is TaskDetailsDeleted,
      listener: (context, state) {
        if (state is TaskDetailsDeleted) {
          context.showSnack(context.l10n.taskDeleted);
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.taskTitle),
            actions: [
              if (state is TaskDetailsSuccess)
                IconButton(
                  tooltip: context.l10n.edit,
                  onPressed: () => context.push('/tasks/${state.task.id}/edit'),
                  icon: const Icon(Icons.edit_outlined),
                ),
              if (state is TaskDetailsSuccess)
                IconButton(
                  tooltip: context.l10n.delete,
                  onPressed: state.busy
                      ? null
                      : () => context.read<TaskDetailsCubit>().delete(),
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          body: switch (state) {
            TaskDetailsInitial() || TaskDetailsLoading() => const AppSkeleton(),
            TaskDetailsDeleted() => const AppLoader(),
            TaskDetailsError(:final failure) => AppRefreshable(
              onRefresh: () => context.read<TaskDetailsCubit>().refresh(),
              child: AppErrorView(
                message: failure.message,
                onRetry: () => context.read<TaskDetailsCubit>().load(taskId),
              ),
            ),
            TaskDetailsSuccess(:final task, :final busy) => _TaskDetailsBody(
              task: task,
              busy: busy,
            ),
          },
        );
      },
    );
  }
}

class _TaskDetailsBody extends StatelessWidget {
  const _TaskDetailsBody({required this.task, required this.busy});

  final Task task;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<TaskDetailsCubit>().refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
        TaskCard(task: task),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusBadge(
              label: task.status.l10n(context.l10n),
              color: switch (task.status) {
                TaskStatus.todo => const Color(0xFF6B7280),
                TaskStatus.inProgress => const Color(0xFF2563EB),
                TaskStatus.done => const Color(0xFF059669),
              },
            ),
            StatusBadge(
              label: task.priority.l10n(context.l10n),
              color: switch (task.priority) {
                TaskPriority.low => const Color(0xFF6B7280),
                TaskPriority.medium => const Color(0xFFD97706),
                TaskPriority.high => const Color(0xFFDC2626),
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(task.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        Text(
          context.l10n.updatedOn(
            DateFormat.yMMMd(context.localeName).add_jm().format(
              task.updatedAt.toLocal(),
            ),
          ),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 24),
        if (!task.isDone)
          FilledButton(
            onPressed: busy
                ? null
                : () => context.read<TaskDetailsCubit>().markDone(),
            child: Text(context.l10n.markCompleted),
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: TaskStatus.values.map((status) {
            return ChoiceChip(
              label: Text(status.l10n(context.l10n)),
              selected: task.status == status,
              onSelected: busy
                  ? null
                  : (_) =>
                        context.read<TaskDetailsCubit>().changeStatus(status),
            );
          }).toList(),
        ),
      ],
      ),
    );
  }
}
