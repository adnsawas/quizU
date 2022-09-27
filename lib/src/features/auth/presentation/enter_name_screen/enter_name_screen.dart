import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/auth/presentation/enter_name_screen/enter_name_screen_controller.dart';
import 'package:quiz_u/src/utils/async_value_error_ui.dart';

class EnterNameScreen extends ConsumerStatefulWidget {
  const EnterNameScreen({super.key});

  @override
  ConsumerState<EnterNameScreen> createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends ConsumerState<EnterNameScreen> {
  final controller = TextEditingController();

  final nameFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(enterNameScreenControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });
    final state = ref.watch(enterNameScreenControllerProvider);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            'Enter your name',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 24),
          TextFormField(
            key: nameFieldKey,
            controller: controller,
            autocorrect: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Full Name',
              hintText: 'e.g. Adnan Sawas',
            ),
            validator: (value) =>
                (value?.isEmpty ?? false) ? 'Please enter a name' : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.name,
          ),
          if (state.isLoading) ...[
            const SizedBox(height: 40),
            const Center(child: CircularProgressIndicator()),
          ],
          const SizedBox(height: 36),
          ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      // validate the name
                      if (nameFieldKey.currentState!.validate()) {
                        // if valid, submit
                        ref
                            .read(enterNameScreenControllerProvider.notifier)
                            .submitName(controller.text);
                      }
                    },
              child: const Text('Submit')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
