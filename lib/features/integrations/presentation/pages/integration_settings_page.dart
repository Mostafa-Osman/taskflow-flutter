import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/classroom/enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/label_localizations.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/integration_cubit.dart';
import '../cubit/integration_state.dart';

class IntegrationSettingsPage extends StatelessWidget {
  const IntegrationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IntegrationCubit, IntegrationState>(
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
          appBar: AppBar(title: Text(l10n.googleClassroom)),
          body: state.loading
              ? const AppSkeleton()
              : RefreshIndicator(
                  onRefresh: () => context.read<IntegrationCubit>().refresh(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                  children: [
                    Text(l10n.googleOptionalHint),
                    const SizedBox(height: 16),
                    if (!state.connected)
                      AppButton(
                        label: l10n.connectGoogleClassroom,
                        loading: state.busy,
                        onPressed: () =>
                            context.read<IntegrationCubit>().connect(),
                      )
                    else ...[
                      Text(
                        l10n.connectionStatus(
                          state.connection!.status.apiValue,
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.defaultGradePolicy,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.approvalVsPublication),
                      const SizedBox(height: 12),
                      ...ConnectionGradeSyncPolicy.values.map(
                        (policy) => RadioListTile<ConnectionGradeSyncPolicy>(
                          title: Text(policy.l10n(l10n)),
                          value: policy,
                          // ignore: deprecated_member_use
                          groupValue: state.connection!.gradeSyncPolicy,
                          // ignore: deprecated_member_use
                          onChanged: state.busy
                              ? null
                              : (value) {
                                  if (value != null) {
                                    unawaited(
                                      context
                                          .read<IntegrationCubit>()
                                          .updatePolicy(value),
                                    );
                                  }
                                },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.importSelectedCourses,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...state.courses.map(
                        (course) => CheckboxListTile(
                          title: Text(course.name),
                          subtitle: Text('${course.section} · ${course.id}'),
                          value: state.selectedCourseIds.contains(course.id),
                          onChanged: (_) => context
                              .read<IntegrationCubit>()
                              .toggleCourse(course.id),
                        ),
                      ),
                      AppButton(
                        label: l10n.importSelectedCourses,
                        loading: state.busy,
                        onPressed: state.selectedCourseIds.isEmpty
                            ? null
                            : () => context
                                  .read<IntegrationCubit>()
                                  .importSelected(),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: state.busy
                            ? null
                            : () =>
                                  context.read<IntegrationCubit>().disconnect(),
                        child: Text(l10n.disconnectGoogleClassroom),
                      ),
                    ],
                  ],
                  ),
                ),
        );
      },
    );
  }

  String? _notice(AppLocalizations l10n, IntegrationState state) {
    return switch (state.notice) {
      IntegrationNotice.connected => l10n.googleConnectedSnack,
      IntegrationNotice.disconnected => l10n.googleDisconnectedSnack,
      IntegrationNotice.policyUpdated => l10n.policyUpdatedSnack,
      IntegrationNotice.imported =>
        l10n.importedCoursesSnack(state.importedCount ?? 0),
      null => null,
    };
  }
}
