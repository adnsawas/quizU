import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_u/src/features/intro/presentation/intro_item.dart';
import 'package:quiz_u/src/routing/router.dart';
import 'package:quiz_u/src/theme/app_colors.dart';
import 'package:concentric_transition/concentric_transition.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: const [
          AppColors.backgroundColor,
          AppColors.primaryColor,
          AppColors.smallItemsBackgroundColor,
          AppColors.primaryColor,
        ],
        pageController: _controller,
        itemCount: 3,
        nextButtonBuilder: (context) => IconButton(
            onPressed: () {
              if (_controller.page == 2) {
                context.goNamed(AppRoute.auth.name);
              }
              _controller.nextPage(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOutSine);
            },
            icon: const Icon(
              Icons.navigate_next_rounded,
              size: 60,
            )),
        itemBuilder: (index) => pages[index],
      ),
    );
  }
}

final pages = <Widget>[
  const IntroItem(
    imagePath: 'assets/intro/intro_1.png',
    title: 'Welcome to QuizU',
    description: 'Test your knowldge in Tech industry through a timed quiz',
  ),
  const IntroItem(
    imagePath: 'assets/intro/intro_2.png',
    title: 'Answer Quickly',
    description: 'Solve as many questions as you can in just 2 minutes',
  ),
  const IntroItem(
    imagePath: 'assets/intro/intro_3.png',
    title: 'Climb the Leaderboard',
    description:
        'Challenge others for highest scores and get into leaderboard list',
  ),
];
