import '../../../../core/errors/failures.dart';
import '../../../../core/network/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      final dto = await _remote.login(email: email, password: password);
      await _local.cacheSession(token: dto.token, user: dto.user);
      return Success(dto.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final dto = await _remote.register(
        name: name,
        email: email,
        password: password,
      );
      await _local.cacheSession(token: dto.token, user: dto.user);
      return Success(dto.toEntity());
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<AuthSession?>> restoreSession() async {
    try {
      final token = await _local.readToken();
      if (token == null || token.isEmpty) {
        return const Success(null);
      }
      try {
        final user = await _remote.me();
        await _local.cacheSession(token: token, user: user);
        return Success(AuthSession(token: token, user: user.toEntity()));
      } catch (error) {
        final failure = FailureMapper.from(error);
        if (failure is UnauthorizedFailure) {
          await _local.clear();
          return const Success(null);
        }
        final cached = await _local.readUser();
        if (cached != null) {
          return Success(AuthSession(token: token, user: cached.toEntity()));
        }
        return Err(failure);
      }
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _local.clear();
      return const Success(null);
    } catch (error) {
      return Err(FailureMapper.from(error));
    }
  }
}
