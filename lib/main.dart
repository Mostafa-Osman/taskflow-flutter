import 'package:flutter/material.dart';

import 'app.dart';
import 'config/env/app_env.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/profile/presentation/cubit/theme_cubit.dart';
import 'injection/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final env = AppEnv.fromDartDefine();
  await configureDependencies(env);

  final authCubit = getIt<AuthCubit>();
  final themeCubit = getIt<ThemeCubit>();
  await themeCubit.load();
  final router = createRouter(authCubit: authCubit, getIt: getIt);

  runApp(
    TaskFlowApp(
      env: env,
      authCubit: authCubit,
      themeCubit: themeCubit,
      router: router,
    ),
  );

  await authCubit.restoreSession();
}
