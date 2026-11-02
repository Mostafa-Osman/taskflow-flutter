import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/class_filter.dart';
import '../entities/school_class.dart';
import '../repositories/class_repository.dart';

class CreateClassUseCase {
  const CreateClassUseCase(this._repository);

  final ClassRepository _repository;

  Future<Result<SchoolClass>> call(CreateClassInput input) {
    final nameError = Validators.required(input.name, field: 'Class name');
    if (nameError != null) {
      return Future.value(Err(ValidationFailure(nameError)));
    }
    return _repository.createClass(input);
  }
}
