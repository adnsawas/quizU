import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/common_widgets/confirm_widget.dart';
import 'package:quiz_u/src/features/auth/presentation/logout_button/logout_button_controller.dart';
import 'package:quiz_u/src/utils/async_value_error_ui.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(logoutButtonControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    final state = ref.watch(logoutButtonControllerProvider);
    return IconButton(
      onPressed: () async {
        final userConfirmed = await showConfirmationDialog(
            context: context, message: 'Are you sure you want to logout?');
        if (userConfirmed) {
          ref.read(logoutButtonControllerProvider.notifier).logout();
        }
      },
      icon: state.isRefreshing
          ? const CircularProgressIndicator()
          : const Icon(Icons.logout),
    );
  }
}
