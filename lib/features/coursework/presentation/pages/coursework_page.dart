import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/classroom/enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/label_localizations.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_refreshable.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/status_badge.dart';
import '../cubit/coursework_cubit.dart';

class CourseworkPage extends StatelessWidget {
  const CourseworkPage({required this.courseworkId, super.key});

  final String courseworkId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CourseworkCubit, CourseworkState>(
      builder: (context, state) {
        final item = state.item;
        return Scaffold(
          appBar: AppBar(title: Text(item?.title ?? l10n.courseworkFallback)),
          body: state.loading
              ? const AppSkeleton()
              : item == null
              ? AppRefreshable(
                  onRefresh: () => context.read<CourseworkCubit>().refresh(),
                  child: AppErrorView(
                    message: state.failure?.message ?? l10n.courseworkNotFound,
                    onRetry: () =>
                        context.read<CourseworkCubit>().load(courseworkId),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => context.read<CourseworkCubit>().refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      l10n.effectivePolicy(item.policy.effectivePolicy.apiValue),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.approvalLocalOnly),
                    const SizedBox(height: 12),
                    ...CourseworkGradeSyncPolicy.values.map(
                      (policy) => RadioListTile<CourseworkGradeSyncPolicy>(
                        title: Text(policy.l10n(l10n)),
                        value: policy,
                        // ignore: deprecated_member_use
                        groupValue: item.policy.gradeSyncPolicy,
                        // ignore: deprecated_member_use
                        onChanged: state.busy
                            ? null
                            : (value) {
                                if (value != null) {
                                  unawaited(
                                    context.read<CourseworkCubit>().updatePolicy(
                                      value,
                                    ),
                                  );
                                }
                              },
                      ),
                    ),
                    const Divider(),
                    Text(
                      l10n.capabilityLabel(item.capabilityState.apiValue),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (item.checkedAt != null)
                      Text(
                        l10n.lastCheck(
                          DateFormat.MMMd(context.localeName).add_jm().format(
                            item.checkedAt!.toLocal(),
                          ),
                        ),
                      ),
                    if (item.unavailableReason != null) ...[
                      const SizedBox(height: 8),
                      Text(item.unavailableReason!),
                    ],
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StatusBadge(
                          label: l10n.eligibleCount(item.counts.eligibleCount),
                        ),
                        StatusBadge(
                          label: l10n.blockedCount(item.counts.blockedCount),
                        ),
                        StatusBadge(
                          label: l10n.pendingCount(item.counts.pendingCount),
                        ),
                        StatusBadge(
                          label: l10n.publishedCount(item.counts.successCount),
                        ),
                        StatusBadge(
                          label: l10n.failedCount(item.counts.failedCount),
                        ),
                        StatusBadge(
                          label: l10n.conflictsCount(item.counts.conflictCount),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () =>
                          context.push('/coursework/$courseworkId/publish'),
                      child: Text(l10n.reviewPublicationPreview),
                    ),
                  ],
                  ),
                ),
        );
      },
    );
  }
}
