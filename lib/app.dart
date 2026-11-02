import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'config/env/app_env.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/profile/domain/app_language.dart';
import 'features/profile/presentation/cubit/locale_cubit.dart';
import 'features/profile/presentation/cubit/theme_cubit.dart';
import 'l10n/app_localizations.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({
    required this.env,
    required this.authCubit,
    required this.themeCubit,
    required this.localeCubit,
    required this.router,
    super.key,
  });

  final AppEnv env;
  final AuthCubit authCubit;
  final ThemeCubit themeCubit;
  final LocaleCubit localeCubit;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider<AppEnv>.value(value: env)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: authCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LocaleCubit, AppLanguage>(
              builder: (context, language) {
                return MaterialApp.router(
                  onGenerateTitle: (context) =>
                      AppLocalizations.of(context).appTitle,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light(),
                  darkTheme: AppTheme.dark(),
                  themeMode: themeMode,
                  locale: language.locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  routerConfig: router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
