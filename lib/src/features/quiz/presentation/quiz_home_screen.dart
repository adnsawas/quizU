import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_u/src/features/quiz/data/quiz_repository.dart';
import 'package:quiz_u/src/routing/router.dart';
import 'package:quiz_u/src/theme/app_colors.dart';

class QuizHomeScreen extends StatelessWidget {
  const QuizHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Hero(
                tag: 'appLogo',
                child: Image.asset('assets/app_icon.png', height: 180)),
            const SizedBox(height: 24),
            Text(
              'QuizU',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: AppColors.secondaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            Text(
              'Ready to test your knowledge and challenge others?',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Consumer(builder: (context, ref, _) {
              final questions = ref.watch(questionsStreamProvider);
              return ElevatedButton(
                  onPressed: questions.isRefreshing
                      ? null
                      : () {
                          context.goNamed(AppRoute.quiz.name);
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('🏁', style: TextStyle(fontSize: 36)),
                      SizedBox(width: 16),
                      Text(
                        'Quiz Me',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ));
            }),
            const SizedBox(height: 24),
            Text(
              'Answer as many questions coorectly within 2 minutes',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
