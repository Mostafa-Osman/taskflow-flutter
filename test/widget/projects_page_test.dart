import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/widgets/app_empty_view.dart';
import 'package:taskflow/core/widgets/app_error_view.dart';
import 'package:taskflow/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:taskflow/features/projects/presentation/cubit/projects_state.dart';
import 'package:taskflow/features/projects/presentation/pages/projects_page.dart';

import '../helpers/l10n.dart';
import '../helpers/mocks.dart';

void main() {
  late MockProjectsCubit cubit;

  setUp(() {
    cubit = MockProjectsCubit();
    when(() => cubit.retry()).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      wrapWithL10n(
        BlocProvider<ProjectsCubit>.value(
          value: cubit,
          child: const ProjectsPage(),
        ),
      ),
    );
  }

  testWidgets('renders empty state', (tester) async {
    whenListen(
      cubit,
      const Stream<ProjectsState>.empty(),
      initialState: const ProjectsState.empty(),
    );
    await pumpPage(tester);
    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text('No projects yet'), findsOneWidget);
  });

  testWidgets('retry from error calls the cubit', (tester) async {
    whenListen(
      cubit,
      const Stream<ProjectsState>.empty(),
      initialState: const ProjectsState.error(NetworkFailure()),
    );
    await pumpPage(tester);
    expect(find.byType(AppErrorView), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pump();
    verify(() => cubit.retry()).called(1);
  });

  testWidgets('success renders project cards', (tester) async {
    whenListen(
      cubit,
      const Stream<ProjectsState>.empty(),
      initialState: ProjectsState.success(projects: [demoProject]),
    );
    await pumpPage(tester);
    expect(find.text('Mobile App Redesign'), findsOneWidget);
  });
}
