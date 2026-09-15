import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../tasks/presentation/cubit/tasks_cubit.dart';
import '../../../tasks/presentation/cubit/tasks_state.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../cubit/project_details_cubit.dart';
import '../cubit/project_details_state.dart';
import '../widgets/project_card.dart';

class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project'),
        actions: [
          IconButton(
            tooltip: 'Add task',
            onPressed: () => context.push('/tasks/new?projectId=$projectId'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
        builder: (context, state) {
          return switch (state) {
            ProjectDetailsInitial() ||
            ProjectDetailsLoading() => const AppLoader(),
            ProjectDetailsError(:final failure) => AppErrorView(
              message: failure.message,
              onRetry: () =>
                  context.read<ProjectDetailsCubit>().load(projectId),
            ),
            ProjectDetailsSuccess(:final project) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ProjectCard(project: project),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const _ProjectTasksList(),
              ],
            ),
          };
        },
      ),
    );
  }
}

class _ProjectTasksList extends StatelessWidget {
  const _ProjectTasksList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return switch (state) {
          TasksInitial() || TasksLoading() => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          TasksEmpty() => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No tasks in this project yet.'),
            ),
          ),
          TasksError(:final failure) => SliverToBoxAdapter(
            child: AppErrorView(
              message: failure.message,
              onRetry: () => context.read<TasksCubit>().retry(),
            ),
          ),
          TasksSuccess(:final items) => SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
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
    );
  }
}
