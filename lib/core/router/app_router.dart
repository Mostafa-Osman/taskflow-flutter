import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/classes/presentation/cubit/class_details_cubit.dart';
import '../../features/classes/presentation/cubit/class_form_cubit.dart';
import '../../features/classes/presentation/cubit/classes_cubit.dart';
import '../../features/classes/presentation/pages/class_details_page.dart';
import '../../features/classes/presentation/pages/class_form_page.dart';
import '../../features/classes/presentation/pages/classes_page.dart';
import '../../features/coursework/presentation/cubit/coursework_cubit.dart';
import '../../features/coursework/presentation/pages/coursework_page.dart';
import '../../features/grade_publication/presentation/cubit/publication_cubit.dart';
import '../../features/grade_publication/presentation/pages/publication_preview_page.dart';
import '../../features/integrations/presentation/cubit/integration_cubit.dart';
import '../../features/integrations/presentation/pages/integration_settings_page.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/projects/presentation/cubit/project_details_cubit.dart';
import '../../features/projects/presentation/cubit/projects_cubit.dart';
import '../../features/projects/presentation/pages/project_details_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/tasks/domain/entities/task_filter.dart';
import '../../features/tasks/presentation/cubit/task_details_cubit.dart';
import '../../features/tasks/presentation/cubit/task_details_state.dart';
import '../../features/tasks/presentation/cubit/task_form_cubit.dart';
import '../../features/tasks/presentation/cubit/tasks_cubit.dart';
import '../../features/tasks/presentation/pages/task_details_page.dart';
import '../../features/tasks/presentation/pages/task_form_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';
import 'app_routes.dart';
import 'auth_refresh_listenable.dart';
import 'not_found_page.dart';
import 'scaffold_with_nav.dart';

GoRouter createRouter({required AuthCubit authCubit, required GetIt getIt}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    errorBuilder: (context, state) => const NotFoundPage(),
    redirect: (context, state) {
      final auth = authCubit.state;
      final location = state.matchedLocation;
      final loggingIn =
          location == AppRoutes.login || location == AppRoutes.register;
      final splash = location == AppRoutes.splash;

      if (auth is AuthInitial) {
        return splash ? null : AppRoutes.splash;
      }

      if (auth is AuthLoading && splash) {
        return null;
      }

      final signedIn = auth is AuthAuthenticated;

      if (!signedIn && !loggingIn && !splash) {
        final from = Uri.encodeComponent('${state.uri}');
        return '${AppRoutes.login}?from=$from';
      }

      if (!signedIn && splash && auth is! AuthLoading) {
        return AppRoutes.login;
      }

      if (signedIn && (loggingIn || splash)) {
        final from = state.uri.queryParameters['from'];
        if (from != null && from.isNotEmpty) {
          return from;
        }
        return AppRoutes.projects;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.notFound,
        builder: (context, state) => const NotFoundPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.projects,
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) {
                      final cubit = getIt<ProjectsCubit>();
                      unawaited(cubit.load());
                      return cubit;
                    },
                    child: const ProjectsPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.classes,
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) {
                      final cubit = getIt<ClassesCubit>();
                      unawaited(cubit.load());
                      return cubit;
                    },
                    child: const ClassesPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) {
                      final cubit = getIt<TasksCubit>();
                      unawaited(cubit.load());
                      return cubit;
                    },
                    child: const TasksPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) {
                  return BlocProvider(
                    create: (_) {
                      final cubit = getIt<NotificationsCubit>();
                      unawaited(cubit.load());
                      return cubit;
                    },
                    child: const ProfilePage(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.classCreate,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<ClassFormCubit>(),
            child: const ClassFormPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.integrations,
        builder: (context, state) {
          return BlocProvider(
            create: (_) {
              final cubit = getIt<IntegrationCubit>();
              unawaited(cubit.load());
              return cubit;
            },
            child: const IntegrationSettingsPage(),
          );
        },
      ),
      GoRoute(
        path: '/classes/:classId',
        builder: (context, state) {
          final classId = state.pathParameters['classId']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) {
                  final cubit = getIt<ClassDetailsCubit>();
                  unawaited(cubit.load(classId));
                  return cubit;
                },
              ),
              BlocProvider(
                create: (_) {
                  final cubit = getIt<IntegrationCubit>();
                  unawaited(cubit.load());
                  return cubit;
                },
              ),
            ],
            child: ClassDetailsPage(classId: classId),
          );
        },
      ),
      GoRoute(
        path: '/coursework/:courseworkId/publish',
        builder: (context, state) {
          final courseworkId = state.pathParameters['courseworkId']!;
          return BlocProvider(
            create: (_) {
              final cubit = getIt<PublicationCubit>();
              unawaited(cubit.load(courseworkId));
              return cubit;
            },
            child: PublicationPreviewPage(courseworkId: courseworkId),
          );
        },
      ),
      GoRoute(
        path: '/coursework/:courseworkId',
        builder: (context, state) {
          final courseworkId = state.pathParameters['courseworkId']!;
          return BlocProvider(
            create: (_) {
              final cubit = getIt<CourseworkCubit>();
              unawaited(cubit.load(courseworkId));
              return cubit;
            },
            child: CourseworkPage(courseworkId: courseworkId),
          );
        },
      ),
      GoRoute(
        path: '/projects/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) {
                  final cubit = getIt<ProjectDetailsCubit>();
                  unawaited(cubit.load(projectId));
                  return cubit;
                },
              ),
              BlocProvider(
                create: (_) {
                  final cubit = getIt<TasksCubit>();
                  unawaited(
                    cubit.load(filter: TaskFilter(projectId: projectId)),
                  );
                  return cubit;
                },
              ),
            ],
            child: ProjectDetailsPage(projectId: projectId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.taskCreate,
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'];
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) {
                  final cubit = getIt<TaskFormCubit>();
                  if (projectId != null) {
                    cubit.setProjectId(projectId);
                  }
                  return cubit;
                },
              ),
              BlocProvider(
                create: (_) {
                  final cubit = getIt<ProjectsCubit>();
                  unawaited(cubit.load());
                  return cubit;
                },
              ),
            ],
            child: const TaskFormPage(),
          );
        },
      ),
      GoRoute(
        path: '/tasks/:taskId/edit',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<TaskFormCubit>()),
              BlocProvider(
                create: (_) {
                  final cubit = getIt<ProjectsCubit>();
                  unawaited(cubit.load());
                  return cubit;
                },
              ),
              BlocProvider(
                create: (_) {
                  final cubit = getIt<TaskDetailsCubit>();
                  unawaited(cubit.load(taskId));
                  return cubit;
                },
              ),
            ],
            child: const _EditTaskBootstrap(),
          );
        },
      ),
      GoRoute(
        path: '/tasks/:taskId',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return BlocProvider(
            create: (_) {
              final cubit = getIt<TaskDetailsCubit>();
              unawaited(cubit.load(taskId));
              return cubit;
            },
            child: TaskDetailsPage(taskId: taskId),
          );
        },
      ),
    ],
  );
}

class _EditTaskBootstrap extends StatelessWidget {
  const _EditTaskBootstrap();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskDetailsCubit, TaskDetailsState>(
      listenWhen: (previous, current) => current is TaskDetailsSuccess,
      listener: (context, state) {
        if (state is TaskDetailsSuccess) {
          context.read<TaskFormCubit>().hydrate(state.task);
        }
      },
      child: const TaskFormPage(),
    );
  }
}
