import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/auth/presentation/enter_mobile_screen/enter_mobile_screen.dart';
import 'package:quiz_u/src/features/auth/presentation/enter_name_screen/enter_name_screen.dart';
import 'package:quiz_u/src/features/auth/presentation/otp_screen/otp_screen.dart';
import 'package:quiz_u/src/theme/app_colors.dart';

class MainAuthScreen extends ConsumerWidget {
  MainAuthScreen({super.key});

  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This listens to page index from the provider down below
    // so it automatically animates to correct page when needed
    ref.listen<int>(mainAuthStepIndexProvider, (_, newIndex) {
      pageController.animateToPage(newIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    });

    return GestureDetector(
      // This focus node is added to hide keyboard whenever
      // any part of the screen is tapped
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Hero(
                  tag: 'appLogo',
                  child: Image.asset('assets/app_icon.png', height: 150)),
              const SizedBox(height: 24),
              Text(
                'QuizU',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      EnterMobileScreen(),
                      OtpScreen(),
                      EnterNameScreen(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final mainAuthStepIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});
