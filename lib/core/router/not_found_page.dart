import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_empty_view.dart';
import 'app_routes.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: AppEmptyView(
        title: 'This page does not exist',
        message: 'The link may be broken or the item was removed.',
        actionLabel: 'Go to projects',
        onAction: () => context.go(AppRoutes.projects),
      ),
    );
  }
}
