import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String email,
    required String password,
  }) {
    final emailError = Validators.email(email);
    final passwordError = Validators.password(password);
    if (emailError != null || passwordError != null) {
      return Future.value(Err(ValidationFailure(emailError ?? passwordError!)));
    }
    return _repository.login(email: email.trim(), password: password);
  }
}
