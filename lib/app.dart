import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/app_state.dart';
import 'routes/app_router.dart';

class RusticKitchenApp extends StatelessWidget {
  const RusticKitchenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Rustic Kitchen',
      theme: AppTheme.light(),
      routerConfig: AppRouter.router(state),
    );
  }
}
