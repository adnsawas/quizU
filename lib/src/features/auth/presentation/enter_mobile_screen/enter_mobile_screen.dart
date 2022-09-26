import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/auth/presentation/enter_mobile_screen/enter_mobile_screen_controller.dart';
import 'package:quiz_u/src/features/auth/presentation/enter_mobile_screen/region_widget.dart';
import 'package:quiz_u/src/features/auth/presentation/main_auth_screen.dart';
import 'package:quiz_u/src/utils/async_value_error_ui.dart';

class EnterMobileScreen extends ConsumerStatefulWidget {
  const EnterMobileScreen({super.key});

  @override
  ConsumerState<EnterMobileScreen> createState() => _EnterMobileScreenState();
}

class _EnterMobileScreenState extends ConsumerState<EnterMobileScreen> {
  final _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<EnterMobileScreenState>(
      enterMobileScreenControllerProvider,
      (_, state) => state.value.showAlertDialogOnError(context),
    );

    final state = ref.watch(enterMobileScreenControllerProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mobile Text Field
        TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              labelText: 'Mobile',
              hintText: '53 555 5555',
              border: const OutlineInputBorder(),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: RegionWidget(
                      initialRegion: state.region,
                      onChange: (region) {
                        ref
                            .read(enterMobileScreenControllerProvider.notifier)
                            .updateRegion(region);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const VerticalDivider(color: Colors.grey),
                ],
              )),
        ),
        const SizedBox(height: 30),
        // Submit Button
        ElevatedButton(
            onPressed: state.value.isLoading
                ? null
                : () {
                    ref
                        .read(enterMobileScreenControllerProvider.notifier)
                        .submitMobile(
                            mobile: _mobileController.text,
                            onSuccess: () {
                              FocusScope.of(context).unfocus();
                              // Show next page by updating the PageController index
                              ref
                                  .read(mainAuthStepIndexProvider.notifier)
                                  .state = 1;
                            });
                  },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: state.value.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Start'),
            )),
      ],
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }
}
