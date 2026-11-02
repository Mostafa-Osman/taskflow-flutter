import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: AppConstants.demoEmail);
  final _password = TextEditingController(text: AppConstants.demoPassword);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) => current is AuthError,
          listener: (context, state) {
            if (state is AuthError) {
              context.showSnack(state.failure.message);
            }
          },
          builder: (context, state) {
            final loading = state is AuthLoading;
            final l10n = context.l10n;
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 32),
                Text(l10n.welcomeBack, style: context.texts.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  l10n.signInSubtitle,
                  style: context.texts.bodyLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: l10n.email,
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: (value) => Validators.email(
                          value,
                          empty: l10n.emailRequired,
                          invalid: l10n.emailInvalid,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: l10n.password,
                        controller: _password,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        validator: (value) => Validators.password(
                          value,
                          empty: l10n.passwordRequired,
                          tooShort: l10n.passwordTooShort,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: l10n.signIn,
                        loading: loading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            unawaited(
                              context.read<AuthCubit>().login(
                                email: _email.text,
                                password: _password.text,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: loading ? null : () => context.go('/register'),
                  child: Text(l10n.createAnAccount),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
