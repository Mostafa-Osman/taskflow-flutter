import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/label_localizations.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_refreshable.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../domain/entities/task_filter.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../widgets/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _search = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _search.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 240) {
      unawaited(context.read<TasksCubit>().loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.tasksTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.newTask,
            onPressed: () => context.push('/tasks/new'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: context.l10n.searchTasks,
              ),
              onSubmitted: (value) =>
                  context.read<TasksCubit>().search(value.trim()),
            ),
          ),
          const _FilterBar(),
          Expanded(
            child: BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                return switch (state) {
                  TasksInitial() || TasksLoading() => const AppSkeleton(),
                  TasksEmpty() => AppRefreshable(
                    onRefresh: () => context.read<TasksCubit>().refresh(),
                    child: AppEmptyView(
                      title: context.l10n.noTasksMatch,
                      message: context.l10n.noTasksMatchMessage,
                      actionLabel: context.l10n.clear,
                      onAction: () => context.read<TasksCubit>().load(
                        filter: const TaskFilter(),
                      ),
                    ),
                  ),
                  TasksError(:final failure) => AppRefreshable(
                    onRefresh: () => context.read<TasksCubit>().refresh(),
                    child: AppErrorView(
                      message: failure.message,
                      onRetry: () => context.read<TasksCubit>().retry(),
                    ),
                  ),
                  TasksSuccess(
                    :final items,
                    :final loadingMore,
                    :final loadMoreFailure,
                    :final hasMore,
                  ) =>
                    RefreshIndicator(
                      onRefresh: () => context.read<TasksCubit>().refresh(),
                      child: ListView.separated(
                        controller: _scroll,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length + 1,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == items.length) {
                            return _PaginationFooter(
                              loadingMore: loadingMore,
                              hasMore: hasMore,
                              loadMoreFailure: loadMoreFailure?.message,
                              onRetry: () =>
                                  context.read<TasksCubit>().retryLoadMore(),
                            );
                          }
                          final task = items[index];
                          return TaskCard(
                            task: task,
                            onTap: () => context.push('/tasks/${task.id}'),
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

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      buildWhen: (previous, current) =>
          previous.filterOrDefault != current.filterOrDefault,
      builder: (context, state) {
        final filter = state.filterOrDefault;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              FilterChip(
                label: Text(filter.status?.l10n(context.l10n) ?? context.l10n.status),
                selected: filter.status != null,
                onSelected: (_) => _pickStatus(context, filter),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(
                  filter.priority?.l10n(context.l10n) ?? context.l10n.priority,
                ),
                selected: filter.priority != null,
                onSelected: (_) => _pickPriority(context, filter),
              ),
              if (filter.status != null || filter.priority != null) ...[
                const SizedBox(width: 8),
                ActionChip(
                  label: Text(context.l10n.clear),
                  onPressed: () => context.read<TasksCubit>().applyFilter(
                    TaskFilter(query: filter.query),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickStatus(BuildContext context, TaskFilter filter) async {
    final selected = await showModalBottomSheet<TaskStatus?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.l10n.allStatuses),
                onTap: () => Navigator.pop(context, null),
              ),
              ...TaskStatus.values.map(
                (status) => ListTile(
                  title: Text(status.l10n(context.l10n)),
                  onTap: () => Navigator.pop(context, status),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted) {
      return;
    }
    unawaited(
      context.read<TasksCubit>().applyFilter(
        filter.copyWith(status: selected, clearStatus: selected == null),
      ),
    );
  }

  Future<void> _pickPriority(BuildContext context, TaskFilter filter) async {
    final selected = await showModalBottomSheet<TaskPriority?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.l10n.allPriorities),
                onTap: () => Navigator.pop(context, null),
              ),
              ...TaskPriority.values.map(
                (priority) => ListTile(
                  title: Text(priority.l10n(context.l10n)),
                  onTap: () => Navigator.pop(context, priority),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted) {
      return;
    }
    unawaited(
      context.read<TasksCubit>().applyFilter(
        filter.copyWith(priority: selected, clearPriority: selected == null),
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({
    required this.loadingMore,
    required this.hasMore,
    required this.onRetry,
    this.loadMoreFailure,
  });

  final bool loadingMore;
  final bool hasMore;
  final String? loadMoreFailure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (loadMoreFailure != null) {
      return AppErrorView(
        message: loadMoreFailure!,
        retryLabel: context.l10n.retryLoadingMore,
        onRetry: onRetry,
      );
    }
    if (loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text(context.l10n.endOfList)),
      );
    }
    return const SizedBox(height: 16);
  }
}

extension on TasksState {
  TaskFilter get filterOrDefault {
    return switch (this) {
      TasksLoading(:final filter) => filter,
      TasksEmpty(:final filter) => filter,
      TasksError(:final filter) => filter,
      TasksSuccess(:final filter) => filter,
      TasksInitial() => const TaskFilter(),
    };
  }
}
