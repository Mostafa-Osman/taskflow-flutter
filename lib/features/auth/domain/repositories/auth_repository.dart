import '../../../../core/result/result.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<AuthSession?>> restoreSession();

  Future<Result<void>> logout();
}
