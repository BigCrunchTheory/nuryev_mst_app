import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';
import 'onboarding/onboarding_screen.dart';
import 'main_screen/main_screen.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, appVM, _) {
        return MaterialApp(
          title: 'Nuryev App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: _buildHome(appVM),
        );
      },
    );
  }

  Widget _buildHome(AppViewModel appVM) {
    if (appVM.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (appVM.hasSubscription) {
      return const MainScreen();
    }

    return const OnboardingScreen(onComplete: _emptyCallback);
  }

  static void _emptyCallback() {
    // Navigation is handled by pushing new routes
  }
}
