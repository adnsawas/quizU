import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quiz_u/src/features/auth/data/auth_repository.dart';
import 'package:quiz_u/src/features/auth/presentation/main_auth_screen.dart';
import 'package:quiz_u/src/features/auth/presentation/otp_screen/otp_screen_controller.dart';
import 'package:quiz_u/src/routing/router.dart';
import 'package:quiz_u/src/utils/async_value_error_ui.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      otpScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(otpScreenControllerProvider);

    return ListView(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Enter one time code you received',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 24),
        PinCodeTextField(
          length: 4,
          enabled: !state.isLoading,
          appContext: context,
          pinTheme: PinTheme(shape: PinCodeFieldShape.circle),
          autoFocus: true,
          autoUnfocus: true,
          useHapticFeedback: true,
          keyboardType: TextInputType.number,
          onChanged: (value) {},
          onCompleted: (value) =>
              ref.read(otpScreenControllerProvider.notifier).submitOtp(
                    otp: value,
                    onSuccess: () {
                      // if logged in user still does not have a name,
                      // take user to latest step (Enter Name Step)
                      if (ref.read(authRepositoryProvider).currentUser?.name ==
                          null) {
                        ref.read(mainAuthStepIndexProvider.notifier).state = 2;
                      } else {
                        // if user reached this step and he does have a name
                        // then just navigate user to home page
                        context.goNamed(AppRoute.home.name);
                      }
                    },
                  ),
        ),
        if (state.isLoading) ...[
          const SizedBox(height: 40),
          const Center(child: CircularProgressIndicator()),
        ],
        const SizedBox(height: 36),
        ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () => ref.read(mainAuthStepIndexProvider.notifier).state = 0,
            child: const Text('Back'))
      ],
    );
  }
}
