import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../extensions/context_extensions.dart';
import '../widgets/app_empty_view.dart';
import 'app_routes.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notFoundTitle)),
      body: AppEmptyView(
        title: l10n.pageDoesNotExist,
        message: l10n.pageDoesNotExistMessage,
        actionLabel: l10n.goToProjects,
        onAction: () => context.go(AppRoutes.projects),
      ),
    );
  }
}
