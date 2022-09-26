import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_u/src/features/auth/data/auth_repository.dart';
import 'package:quiz_u/src/features/splash/presentation/splash_screen_controller.dart';
import 'package:quiz_u/src/routing/router.dart';
import 'package:quiz_u/src/utils/async_value_error_ui.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    ref.read(splashScreenControllerProvider.notifier).initialize().then((_) {
      if (ref.read(authRepositoryProvider).isValidUser) {
        context.goNamed(AppRoute.home.name);
      } else {
        context.goNamed(AppRoute.auth.name);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(splashScreenControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));

    // final state = ref.watch(splashScreenControllerProvider);
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'appLogo',
          child: Image.asset('assets/app_icon.png', height: 180),
        ),
      ),
    );
  }
}
