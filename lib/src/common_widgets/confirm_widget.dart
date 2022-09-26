import 'package:flutter/material.dart';
import 'package:quiz_u/src/theme/app_colors.dart';

Future<bool> showConfirmationDialog(
    {required BuildContext context, required String message}) async {
  final confirmationResult = await showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Confirm',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor)),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              Column(
                children: [
                  OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel')),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Confirm')),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return confirmationResult ?? false;
}
