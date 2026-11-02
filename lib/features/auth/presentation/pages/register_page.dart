import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: Text(context.l10n.createAccount)),
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AppTextField(
                            label: l10n.name,
                            controller: _name,
                            textInputAction: TextInputAction.next,
                            validator: (value) => Validators.name(
                              value,
                              empty: l10n.nameRequired,
                              tooShort: l10n.nameTooShort,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: l10n.email,
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
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
                            validator: (value) => Validators.password(
                              value,
                              empty: l10n.passwordRequired,
                              tooShort: l10n.passwordTooShort,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            label: l10n.createAccount,
                        loading: loading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            unawaited(
                              context.read<AuthCubit>().register(
                                name: _name.text,
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
                  onPressed: loading ? null : () => context.go('/login'),
                  child: Text(l10n.alreadyHaveAccount),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
