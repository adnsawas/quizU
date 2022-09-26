import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_number/phone_number.dart' as phone_number_plugin;

import 'package:quiz_u/src/constants/regions.dart';
import 'package:quiz_u/src/features/auth/application/auth_service.dart';

// This controller class hold the state of currently selected region
///
/// It is of type [AsyncValue] so the controller can track when there is an
/// asynchoronus operation going on
///
/// This selected operation is iniitally defaulted to Saudi Arabia Region
class EnterMobileScreenController
    extends StateNotifier<EnterMobileScreenState> {
  EnterMobileScreenController(this.auth)
      : super(EnterMobileScreenState(
          region: regions.firstWhere((region) => region.code == 'SA'),
          value: const AsyncData(null),
        ));

  final AuthService auth;

  void updateRegion(Region region) {
    state = state.copyWith(value: AsyncData(region));
  }

  Future<bool> validateMobileNumber(String mobileNumber) async {
    // combine region dial code and entered mobile number
    String fullMobileNumber = '${state.region.dialCode}$mobileNumber';
    return await phone_number_plugin.PhoneNumberUtil()
        .validate(fullMobileNumber);
  }

  Future<void> submitMobile(
      {required String mobile, required VoidCallback onSuccess}) async {
    final isValid = await validateMobileNumber(mobile);
    if (isValid) {
      state = state.copyWith(value: const AsyncLoading());
      final newState = await AsyncValue.guard(
          () => auth.submitMobile('${state.region.dialCode}$mobile'));
      state = state.copyWith(value: newState);
      onSuccess();
    } else {
      state = state.copyWith(value: const AsyncError('Invalid mobile number'));
    }
  }
}

class EnterMobileScreenState {
  final Region region;
  final AsyncValue value;

  EnterMobileScreenState(
      {required this.region, this.value = const AsyncData(null)});

  EnterMobileScreenState copyWith({
    Region? region,
    String? validatorString,
    AsyncValue? value,
  }) {
    return EnterMobileScreenState(
      region: region ?? this.region,
      value: value ?? this.value,
    );
  }
}

final enterMobileScreenControllerProvider =
    StateNotifierProvider<EnterMobileScreenController, EnterMobileScreenState>(
        (ref) {
  final authService = ref.watch(authServiceProvider);
  return EnterMobileScreenController(authService);
});
