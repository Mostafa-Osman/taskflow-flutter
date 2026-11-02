import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/classroom/enums.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/result/result.dart';
import 'package:taskflow/features/classes/domain/entities/class_filter.dart';
import 'package:taskflow/features/classes/domain/entities/school_class.dart';
import 'package:taskflow/features/classes/domain/repositories/class_repository.dart';
import 'package:taskflow/features/classes/domain/usecases/create_class_usecase.dart';

class MockClassRepository extends Mock implements ClassRepository {}

void main() {
  late MockClassRepository repository;
  late CreateClassUseCase useCase;

  final created = SchoolClass(
    id: 'cls-1',
    tenantId: 'tenant-a',
    ownerTeacherId: 'u-jane',
    name: 'Homeroom',
    sourceType: ClassSourceType.native,
    status: ClassStatus.active,
    createdAt: DateTime.utc(2026, 10, 1),
    updatedAt: DateTime.utc(2026, 10, 1),
    connected: false,
    hasSyncIssue: false,
  );

  setUp(() {
    repository = MockClassRepository();
    useCase = CreateClassUseCase(repository);
    registerFallbackValue(
      const CreateClassInput(name: 'Homeroom'),
    );
  });

  test('rejects an empty name before calling the repository', () async {
    final result = await useCase(const CreateClassInput(name: '  '));
    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(() => repository.createClass(any()));
  });

  test('creates a Native class without requiring Google Classroom', () async {
    when(
      () => repository.createClass(any()),
    ).thenAnswer((_) async => Success(created));

    final result = await useCase(const CreateClassInput(name: 'Homeroom'));

    expect(result.valueOrNull?.sourceType, ClassSourceType.native);
    expect(result.valueOrNull?.connected, isFalse);
  });
}
