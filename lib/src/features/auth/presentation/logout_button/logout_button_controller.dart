import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/auth/application/auth_service.dart';

class LogoutButtonController extends StateNotifier<AsyncValue<void>> {
  LogoutButtonController(this.authService) : super(const AsyncData(null));

  final AuthService authService;

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authService.logout());
  }
}

final logoutButtonControllerProvider =
    StateNotifierProvider<LogoutButtonController, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return LogoutButtonController(authService);
});
