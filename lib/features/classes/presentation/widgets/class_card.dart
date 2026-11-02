import 'package:flutter/material.dart';

import '../../../../core/classroom/enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/school_class.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({required this.schoolClass, super.key, this.onTap});

  final SchoolClass schoolClass;
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
              Text(
                schoolClass.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusBadge(
                    label: schoolClass.isNative
                        ? context.l10n.sourceNative
                        : context.l10n.sourceImported,
                  ),
                  if (schoolClass.connected)
                    StatusBadge(label: context.l10n.googleConnected),
                  if (schoolClass.hasSyncIssue)
                    StatusBadge(
                      label: context.l10n.syncIssue,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  if (schoolClass.subject != null)
                    StatusBadge(label: schoolClass.subject!),
                  StatusBadge(
                    label: schoolClass.status == ClassStatus.active
                        ? context.l10n.statusActive
                        : context.l10n.statusArchived,
                  ),
                ],
              ),
              if (schoolClass.externalSnapshot != null) ...[
                const SizedBox(height: 8),
                Text(
                  context.l10n.externalLabel(
                    '${schoolClass.externalSnapshot!['name']}',
                    '${schoolClass.externalSnapshot!['section']}',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
