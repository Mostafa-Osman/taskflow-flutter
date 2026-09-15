import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/result/result.dart';
import 'package:taskflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow/features/auth/presentation/cubit/auth_state.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockLoginUseCase login;
  late MockRegisterUseCase register;
  late MockLogoutUseCase logout;
  late MockRestoreSessionUseCase restore;
  late MockAppLogger logger;
  late MockAnalytics analytics;
  late MockCrashReporter crashReporter;

  AuthCubit build() {
    return AuthCubit(
      loginUseCase: login,
      registerUseCase: register,
      logoutUseCase: logout,
      restoreSessionUseCase: restore,
      logger: logger,
      analytics: analytics,
      crashReporter: crashReporter,
    );
  }

  setUpAll(registerFallbackValues);

  setUp(() {
    login = MockLoginUseCase();
    register = MockRegisterUseCase();
    logout = MockLogoutUseCase();
    restore = MockRestoreSessionUseCase();
    logger = MockAppLogger();
    analytics = MockAnalytics();
    crashReporter = MockCrashReporter();
    when(
      () => analytics.logEvent(any(), parameters: any(named: 'parameters')),
    ).thenAnswer((_) async {});
    when(() => analytics.setUserId(any())).thenAnswer((_) async {});
    when(() => crashReporter.setUserId(any())).thenAnswer((_) async {});
  });

  blocTest<AuthCubit, AuthState>(
    'restoreSession emits unauthenticated when no session exists',
    build: () {
      when(() => restore()).thenAnswer((_) async => const Success(null));
      return build();
    },
    act: (cubit) => cubit.restoreSession(),
    expect: () => const [AuthState.loading(), AuthState.unauthenticated()],
  );

  blocTest<AuthCubit, AuthState>(
    'login emits authenticated on success',
    build: () {
      when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Success(demoSession));
      return build();
    },
    act: (cubit) =>
        cubit.login(email: 'jane@taskflow.dev', password: 'password123'),
    expect: () => const [
      AuthState.loading(),
      AuthState.authenticated(demoSession),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'login emits error on failure',
    build: () {
      when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async =>
            const Err(UnauthorizedFailure('Invalid email or password.')),
      );
      return build();
    },
    act: (cubit) => cubit.login(email: 'jane@taskflow.dev', password: 'nope'),
    expect: () => const [
      AuthState.loading(),
      AuthState.error(UnauthorizedFailure('Invalid email or password.')),
    ],
  );
}
