import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          AppColors.secondaryColor,
          AppColors.primaryColor,
          AppColors.backgroundColor,
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
  Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(Icons.home, size: 80), Text('Screen 1')]),
  Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(Icons.query_builder, size: 80), Text('Screen 2')]),
  Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.text_snippet_outlined, size: 80),
        Text('Screen 3')
      ]),
];
