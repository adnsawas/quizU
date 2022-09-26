import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/auth/application/auth_service.dart';

class EnterNameController extends StateNotifier<AsyncValue<void>> {
  EnterNameController(this.auth) : super(const AsyncData(null));

  final AuthService auth;

  Future<void> submitName(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => auth.submitName(name));
  }
}

final enterNameScreenControllerProvider =
    StateNotifierProvider<EnterNameController, AsyncValue>((ref) {
  final authService = ref.watch(authServiceProvider);
  return EnterNameController(authService);
});
