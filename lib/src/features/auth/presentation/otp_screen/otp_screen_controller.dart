import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/auth/application/auth_service.dart';

class OtpScreenController extends StateNotifier<AsyncValue<void>> {
  OtpScreenController(this.auth) : super(const AsyncData(null));

  final AuthService auth;

  Future<void> submitOtp(
      {required String otp, required VoidCallback onSuccess}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => auth.submitOtp(otp: otp));
    if (!state.hasError) {
      onSuccess();
    }
  }
}

final otpScreenControllerProvider =
    StateNotifierProvider<OtpScreenController, AsyncValue>((ref) {
  final authService = ref.watch(authServiceProvider);
  return OtpScreenController(authService);
});
