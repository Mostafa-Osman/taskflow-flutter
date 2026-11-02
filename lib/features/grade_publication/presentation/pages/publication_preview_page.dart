import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_refreshable.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/publication_cubit.dart';
import '../cubit/publication_state.dart';

class PublicationPreviewPage extends StatelessWidget {
  const PublicationPreviewPage({required this.courseworkId, super.key});

  final String courseworkId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublicationCubit, PublicationState>(
      listenWhen: (previous, current) =>
          current.failure != null || current.notice != null,
      listener: (context, state) {
        final l10n = context.l10n;
        final text = state.failure?.message ?? _notice(l10n, state);
        if (text != null) {
          context.showSnack(text);
        }
      },
      builder: (context, state) {
        final l10n = context.l10n;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.publishGrades)),
          body: state.loading
              ? const AppSkeleton()
              : state.coursework == null
              ? AppRefreshable(
                  onRefresh: () => context.read<PublicationCubit>().refresh(),
                  child: AppErrorView(
                    message:
                        state.failure?.message ?? l10n.unableToLoadPreview,
                    onRetry: () =>
                        context.read<PublicationCubit>().load(courseworkId),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => context.read<PublicationCubit>().refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      state.coursework!.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.publicationPreviewHint),
                    if (state.coursework!.unavailableReason != null) ...[
                      const SizedBox(height: 8),
                      Text(state.coursework!.unavailableReason!),
                    ],
                    const SizedBox(height: 16),
                    ...state.items.map(
                      (item) => Card(
                        child: CheckboxListTile(
                          value: state.selectedIds.contains(item.result.id),
                          onChanged: item.eligible
                              ? (_) => context.read<PublicationCubit>().toggle(
                                  item.result.id,
                                )
                              : null,
                          title: Text(
                            l10n.scoreLabel(
                              '${item.result.score}',
                              '${item.result.maxScore}',
                            ),
                          ),
                          subtitle: Text(
                            item.eligible
                                ? l10n.eligible
                                : item.blockedReason ?? l10n.blocked,
                          ),
                          secondary: StatusBadge(
                            label: item.result.approved
                                ? l10n.approvedLocally
                                : l10n.notApproved,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: l10n.publishSelected,
                      loading: state.busy,
                      onPressed: state.selectedIds.isEmpty
                          ? null
                          : () => context
                                .read<PublicationCubit>()
                                .publishSelected(),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: state.busy
                          ? null
                          : () => context
                                .read<PublicationCubit>()
                                .publishAllEligible(),
                      child: Text(l10n.publishAllEligible),
                    ),
                    if (state.attempts.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        l10n.latestApiOutcomes,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ...state.attempts.map(
                        (attempt) => ListTile(
                          title: Text(attempt.status.apiValue),
                          subtitle: Text(
                            attempt.lastErrorMessage ??
                                l10n.verifiedGrade(
                                  '${attempt.externalGradeAfter ?? 'n/a'}',
                                ),
                          ),
                          trailing:
                              attempt.status.apiValue == 'FAILED' ||
                                  attempt.status.apiValue == 'CONFLICT'
                              ? TextButton(
                                  onPressed: () => context
                                      .read<PublicationCubit>()
                                      .retry(attempt.id),
                                  child: Text(l10n.retry),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ],
                  ),
                ),
        );
      },
    );
  }

  String? _notice(AppLocalizations l10n, PublicationState state) {
    return switch (state.notice) {
      PublicationNotice.retry => l10n.retryStatus(state.noticeStatus ?? ''),
      PublicationNotice.finished => l10n.publicationFinished,
      null => null,
    };
  }
}
