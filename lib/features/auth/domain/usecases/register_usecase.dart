import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String name,
    required String email,
    required String password,
  }) {
    final nameError = Validators.name(name);
    final emailError = Validators.email(email);
    final passwordError = Validators.password(password);
    if (nameError != null || emailError != null || passwordError != null) {
      return Future.value(
        Err(ValidationFailure(nameError ?? emailError ?? passwordError!)),
      );
    }
    return _repository.register(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );
  }
}
