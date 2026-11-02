import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/label_localizations.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.task, super.key, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: Theme.of(context).textTheme.titleMedium),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusBadge(
                    label: task.status.l10n(context.l10n),
                    color: _statusColor(task.status),
                  ),
                  StatusBadge(
                    label: task.priority.l10n(context.l10n),
                    color: _priorityColor(task.priority),
                  ),
                  if (task.dueDate != null)
                    StatusBadge(
                      label: DateFormat.MMMd(context.localeName).format(
                        task.dueDate!.toLocal(),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(TaskStatus status) {
    return switch (status) {
      TaskStatus.todo => const Color(0xFF6B7280),
      TaskStatus.inProgress => const Color(0xFF2563EB),
      TaskStatus.done => const Color(0xFF059669),
    };
  }

  Color _priorityColor(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => const Color(0xFF6B7280),
      TaskPriority.medium => const Color(0xFFD97706),
      TaskPriority.high => const Color(0xFFDC2626),
    };
  }
}
