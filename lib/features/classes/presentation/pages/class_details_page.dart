import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_refreshable.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../integrations/domain/entities/google_connection.dart';
import '../../../integrations/presentation/cubit/integration_cubit.dart';
import '../../../integrations/presentation/cubit/integration_state.dart';
import '../cubit/class_details_cubit.dart';
import '../cubit/class_details_state.dart';

class ClassDetailsPage extends StatelessWidget {
  const ClassDetailsPage({required this.classId, super.key});

  final String classId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.classTitle)),
          body: switch (state) {
            ClassDetailsInitial() ||
            ClassDetailsLoading() => const AppSkeleton(),
            ClassDetailsError(:final failure) => AppRefreshable(
              onRefresh: () => context.read<ClassDetailsCubit>().refresh(),
              child: AppErrorView(
                message: failure.message,
                onRetry: () => context.read<ClassDetailsCubit>().load(classId),
              ),
            ),
            ClassDetailsSuccess(
              :final schoolClass,
              :final coursework,
              :final busy,
            ) =>
              RefreshIndicator(
                onRefresh: () => context.read<ClassDetailsCubit>().refresh(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    schoolClass.displayName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      StatusBadge(
                        label: schoolClass.isNative
                            ? l10n.sourceNative
                            : l10n.sourceImported,
                      ),
                      if (schoolClass.connected)
                        StatusBadge(label: l10n.mapped),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.locallyManaged,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.localClassFields),
                    subtitle: Text(
                      l10n.noLocalNotesLine(
                        schoolClass.displayName,
                        schoolClass.description.isEmpty
                            ? l10n.noLocalNotes
                            : schoolClass.description,
                        schoolClass.subject ?? l10n.noSubject,
                      ),
                    ),
                    isThreeLine: true,
                  ),
                  if (schoolClass.externalSnapshot != null) ...[
                    Text(
                      l10n.externallySynchronized,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${schoolClass.externalSnapshot!['name']}'),
                      subtitle: Text(
                        l10n.externalSectionRoom(
                          '${schoolClass.externalSnapshot!['section']}',
                          '${schoolClass.externalSnapshot!['room']}',
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  if (schoolClass.mapping == null)
                    FilledButton(
                      onPressed: busy
                          ? null
                          : () => unawaited(_mapCourse(context)),
                      child: Text(l10n.mapExistingCourse),
                    )
                  else ...[
                    OutlinedButton(
                      onPressed: busy
                          ? null
                          : () => context.read<ClassDetailsCubit>().sync(),
                      child: Text(l10n.synchronizeCourse),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: busy
                          ? null
                          : () => context.read<ClassDetailsCubit>().unmap(),
                      child: Text(l10n.unmapExternalCourse),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    l10n.coursework,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (coursework.isEmpty)
                    Text(l10n.noCourseworkYet)
                  else
                    ...coursework.map(
                      (item) => Card(
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(
                            l10n.policyLabel(
                              item.policy.effectivePolicy.apiValue,
                              item.capabilityState.apiValue,
                            ),
                          ),
                          onTap: () => context.push('/coursework/${item.id}'),
                        ),
                      ),
                    ),
                ],
                ),
              ),
          },
        );
      },
    );
  }

  Future<void> _mapCourse(BuildContext context) async {
    final cubit = context.read<IntegrationCubit>();
    await cubit.refreshCourses();
    if (!context.mounted) {
      return;
    }
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<ExternalCourseOption>(
      context: context,
      builder: (context) {
        return BlocBuilder<IntegrationCubit, IntegrationState>(
          bloc: cubit,
          builder: (context, state) {
            if (state.courses.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.connectBrowseFirst),
              );
            }
            return ListView(
              children: state.courses
                  .map(
                    (course) => ListTile(
                      title: Text(course.name),
                      subtitle: Text('${course.section} · ${course.id}'),
                      onTap: () => Navigator.pop(context, course),
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
    if (selected == null || !context.mounted) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmMapping),
        content: Text(l10n.confirmMappingMessage(selected.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ClassDetailsCubit>().mapExisting(selected.id);
      if (context.mounted) {
        context.showSnack(l10n.mappingSaved);
      }
    }
  }
}
