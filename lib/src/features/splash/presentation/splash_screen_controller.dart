import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/auth/application/auth_service.dart';

class SplashScreenController extends StateNotifier<AsyncValue> {
  SplashScreenController(this.authService) : super(const AsyncData(null));

  final AuthService authService;

  Future<void> initialize() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authService.initialize());
  }
}

final splashScreenControllerProvider =
    StateNotifierProvider<SplashScreenController, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SplashScreenController(authService);
});
