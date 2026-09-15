import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/crash/crash_reporter.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required RestoreSessionUseCase restoreSessionUseCase,
    required AppLogger logger,
    required Analytics analytics,
    required CrashReporter crashReporter,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _restoreSessionUseCase = restoreSessionUseCase,
       _logger = logger,
       _analytics = analytics,
       _crashReporter = crashReporter,
       super(const AuthState.initial());

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;
  final AppLogger _logger;
  final Analytics _analytics;
  final CrashReporter _crashReporter;

  bool get isAuthenticated => state is AuthAuthenticated;

  AuthSession? get session => switch (state) {
    AuthAuthenticated(:final session) => session,
    _ => null,
  };

  Future<void> restoreSession() async {
    emit(const AuthState.loading());
    final result = await _restoreSessionUseCase();
    result.fold(
      (failure) {
        _logger.warning('Session restore failed', error: failure);
        emit(const AuthState.unauthenticated());
      },
      (session) {
        if (session == null) {
          emit(const AuthState.unauthenticated());
          return;
        }
        unawaited(_identify(session));
        emit(AuthState.authenticated(session));
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(email: email, password: password);
    result.fold(
      (failure) {
        _logger.warning('Login failed', error: failure);
        emit(AuthState.error(failure));
      },
      (session) {
        unawaited(_identify(session));
        unawaited(_analytics.logEvent('login_success'));
        emit(AuthState.authenticated(session));
      },
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthState.loading());
    final result = await _registerUseCase(
      name: name,
      email: email,
      password: password,
    );
    result.fold(
      (failure) {
        _logger.warning('Register failed', error: failure);
        emit(AuthState.error(failure));
      },
      (session) {
        unawaited(_identify(session));
        unawaited(_analytics.logEvent('register_success'));
        emit(AuthState.authenticated(session));
      },
    );
  }

  Future<void> logout() async {
    final result = await _logoutUseCase();
    result.fold(
      (failure) {
        _logger.warning('Logout failed', error: failure);
        emit(AuthState.error(failure));
      },
      (_) {
        unawaited(_analytics.setUserId(null));
        unawaited(_crashReporter.setUserId(null));
        emit(const AuthState.unauthenticated());
      },
    );
  }

  Future<void> _identify(AuthSession session) async {
    await _analytics.setUserId(session.user.id);
    await _crashReporter.setUserId(session.user.id);
  }
}
