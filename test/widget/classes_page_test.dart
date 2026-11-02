import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/classroom/enums.dart';
import 'package:taskflow/features/classes/domain/entities/class_filter.dart';
import 'package:taskflow/features/classes/domain/entities/school_class.dart';
import 'package:taskflow/features/classes/presentation/cubit/classes_cubit.dart';
import 'package:taskflow/features/classes/presentation/cubit/classes_state.dart';
import 'package:taskflow/features/classes/presentation/pages/classes_page.dart';

import '../helpers/l10n.dart';

class MockClassesCubit extends MockCubit<ClassesState> implements ClassesCubit {}

void main() {
  late MockClassesCubit cubit;

  setUp(() {
    cubit = MockClassesCubit();
    when(() => cubit.retry()).thenAnswer((_) async {});
  });

  testWidgets('empty Native dashboard still offers create without Google', (
    tester,
  ) async {
    whenListen(
      cubit,
      const Stream<ClassesState>.empty(),
      initialState: const ClassesEmpty(),
    );
    await tester.pumpWidget(
      wrapWithL10n(
        BlocProvider<ClassesCubit>.value(
          value: cubit,
          child: const ClassesPage(),
        ),
      ),
    );
    expect(
      find.text(
        'Create a Native class anytime. Google Classroom is optional.',
      ),
      findsOneWidget,
    );
    expect(find.text('Create Native class'), findsWidgets);
  });

  testWidgets('renders Native and imported classes together', (tester) async {
    whenListen(
      cubit,
      const Stream<ClassesState>.empty(),
      initialState: ClassesSuccess(
        items: [
          SchoolClass(
            id: 'cls-1',
            tenantId: 'tenant-a',
            ownerTeacherId: 'u-1',
            name: 'Homeroom',
            sourceType: ClassSourceType.native,
            status: ClassStatus.active,
            createdAt: DateTime.utc(2026, 10, 1),
            updatedAt: DateTime.utc(2026, 10, 1),
            connected: false,
            hasSyncIssue: false,
          ),
        ],
        filter: const ClassFilter(),
      ),
    );
    await tester.pumpWidget(
      wrapWithL10n(
        BlocProvider<ClassesCubit>.value(
          value: cubit,
          child: const ClassesPage(),
        ),
      ),
    );
    expect(find.text('Homeroom'), findsOneWidget);
    expect(find.text('Native'), findsWidgets);
  });
}
