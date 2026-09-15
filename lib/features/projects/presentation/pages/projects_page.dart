import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';
import '../widgets/project_card.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          return switch (state) {
            ProjectsInitial() || ProjectsLoading() => const AppSkeleton(),
            ProjectsEmpty() => const AppEmptyView(
              title: 'No projects yet',
              message: 'Projects will appear here once they are created.',
            ),
            ProjectsError(:final failure) => AppErrorView(
              message: failure.message,
              onRetry: () => context.read<ProjectsCubit>().retry(),
            ),
            ProjectsSuccess(:final projects, :final refreshing) =>
              RefreshIndicator(
                onRefresh: () => context.read<ProjectsCubit>().refresh(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: projects.length + (refreshing ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index >= projects.length) {
                      return const LinearProgressIndicator();
                    }
                    final project = projects[index];
                    return ProjectCard(
                      project: project,
                      onTap: () => context.push('/projects/${project.id}'),
                    );
                  },
                ),
              ),
          };
        },
      ),
    );
  }
}
