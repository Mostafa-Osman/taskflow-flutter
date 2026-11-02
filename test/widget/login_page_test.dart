import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:taskflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:taskflow/features/auth/presentation/pages/login_page.dart';

import '../helpers/l10n.dart';
import '../helpers/mocks.dart';

void main() {
  late MockAuthCubit cubit;

  setUp(() {
    cubit = MockAuthCubit();
    whenListen(
      cubit,
      const Stream<AuthState>.empty(),
      initialState: const AuthState.unauthenticated(),
    );
    when(
      () => cubit.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpLogin(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => BlocProvider<AuthCubit>.value(
            value: cubit,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const SizedBox(),
        ),
      ],
    );
    await tester.pumpWidget(wrapRouterWithL10n(router));
  }

  testWidgets('shows validation errors for empty credentials', (tester) async {
    await pumpLogin(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), '');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Email is required.'), findsOneWidget);
    expect(find.text('Password is required.'), findsOneWidget);
    verifyNever(
      () => cubit.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('submits valid credentials to AuthCubit', (tester) async {
    await pumpLogin(tester);
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    verify(
      () => cubit.login(email: 'jane@taskflow.dev', password: 'password123'),
    ).called(1);
  });
}
