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

  void submit() {
    ref.read(enterMobileScreenControllerProvider.notifier).submitMobile(
        mobile: _mobileController.text,
        onSuccess: () {
          FocusScope.of(context).unfocus();
          // Show next page by updating the PageController index
          ref.read(mainAuthStepIndexProvider.notifier).state = 1;
        });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EnterMobileScreenState>(
      enterMobileScreenControllerProvider,
      (_, state) => state.value.showAlertDialogOnError(context),
    );

    final state = ref.watch(enterMobileScreenControllerProvider);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            'Enter your mobile number',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 24),
          // Mobile Text Field
          TextFormField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            onFieldSubmitted: (value) => submit,
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
                              .read(
                                  enterMobileScreenControllerProvider.notifier)
                              .updateRegion(region);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const VerticalDivider(color: Colors.grey),
                  ],
                )),
          ),

          if (state.value.isLoading) ...[
            const SizedBox(height: 40),
            const Center(child: CircularProgressIndicator()),
          ],
          const SizedBox(height: 30),
          // Submit Button
          ElevatedButton(
              onPressed: state.value.isLoading ? null : () => submit(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Start'),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }
}
