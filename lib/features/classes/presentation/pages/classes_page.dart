import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/classroom/enums.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_refreshable.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../domain/entities/class_filter.dart';
import '../cubit/classes_cubit.dart';
import '../cubit/classes_state.dart';
import '../widgets/class_card.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.classesTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.integrationSettings,
            onPressed: () => context.push(AppRoutes.integrations),
            icon: const Icon(Icons.hub_outlined),
          ),
          IconButton(
            tooltip: context.l10n.createNativeClass,
            onPressed: () => context.push(AppRoutes.classCreate),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const _ClassFilters(),
          Expanded(
            child: BlocBuilder<ClassesCubit, ClassesState>(
              builder: (context, state) {
                return switch (state) {
                  ClassesInitial() || ClassesLoading() => const AppSkeleton(),
                  ClassesEmpty() => AppRefreshable(
                    onRefresh: () => context.read<ClassesCubit>().refresh(),
                    child: AppEmptyView(
                      title: context.l10n.noClassesYet,
                      message: context.l10n.noClassesMessage,
                      actionLabel: context.l10n.createNativeClass,
                      onAction: () => context.push(AppRoutes.classCreate),
                    ),
                  ),
                  ClassesError(:final failure) => AppRefreshable(
                    onRefresh: () => context.read<ClassesCubit>().refresh(),
                    child: AppErrorView(
                      message: failure.message,
                      onRetry: () => context.read<ClassesCubit>().retry(),
                    ),
                  ),
                  ClassesSuccess(:final items) => RefreshIndicator(
                    onRefresh: () => context.read<ClassesCubit>().refresh(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final schoolClass = items[index];
                        return ClassCard(
                          schoolClass: schoolClass,
                          onTap: () =>
                              context.push('/classes/${schoolClass.id}'),
                        );
                      },
                    ),
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassFilters extends StatelessWidget {
  const _ClassFilters();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassesCubit, ClassesState>(
      builder: (context, state) {
        final filter = switch (state) {
          ClassesLoading(:final filter) => filter,
          ClassesEmpty(:final filter) => filter,
          ClassesError(:final filter) => filter,
          ClassesSuccess(:final filter) => filter,
          ClassesInitial() => const ClassFilter(),
        };
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              FilterChip(
                label: Text(context.l10n.filterAll),
                selected:
                    !filter.connectedOnly &&
                    !filter.syncIssuesOnly &&
                    filter.sourceType == null,
                onSelected: (_) => unawaited(
                  context.read<ClassesCubit>().applyFilter(const ClassFilter()),
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(context.l10n.filterNative),
                selected: filter.sourceType == ClassSourceType.native,
                onSelected: (_) => unawaited(
                  context.read<ClassesCubit>().applyFilter(
                    const ClassFilter(sourceType: ClassSourceType.native),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(context.l10n.filterGoogleConnected),
                selected: filter.connectedOnly,
                onSelected: (_) => unawaited(
                  context.read<ClassesCubit>().applyFilter(
                    const ClassFilter(connectedOnly: true),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(context.l10n.filterSyncIssues),
                selected: filter.syncIssuesOnly,
                onSelected: (_) => unawaited(
                  context.read<ClassesCubit>().applyFilter(
                    const ClassFilter(syncIssuesOnly: true),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
