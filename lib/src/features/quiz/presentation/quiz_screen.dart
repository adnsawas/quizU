import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_u/src/features/quiz/application/quiz_engine.dart';
import 'package:quiz_u/src/features/quiz/application/quiz_timer.dart';
import 'package:quiz_u/src/features/quiz/presentation/count_down_widget.dart';
import 'package:quiz_u/src/features/quiz/presentation/question_widget.dart';
import 'package:quiz_u/src/routing/router.dart';
import 'package:quiz_u/src/theme/app_colors.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    ref.read(quizEngineProvider).startQuiz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // listen to quizState in quizEngine to determine where to navigate
    ref.watch(quizStateStreamProvider).whenData((quizState) {
      if (quizState == QuizState.win) {
        // show winning screen
        Future.microtask(() => context.goNamed(AppRoute.win.name));
      }
      if (quizState == QuizState.lose) {
        // show lose screen
        Future.microtask(() => context.goNamed(AppRoute.lose.name));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quiz Timer
            Consumer(builder: (context, ref, _) {
              final remainingTimeInSeconds =
                  ref.watch(remainingTimeInSecondsStreamProvider).value;
              return CountDownWidget(seconds: remainingTimeInSeconds ?? 0);
            }),
            // Question Widget
            Consumer(
              builder: (context, ref, _) {
                final question = ref.watch(currentQuestionProvider);
                if (question.value != null) {
                  return QuestionWidget(
                    question: question.value!,
                    onAnswer: (userAnswer) {
                      ref.read(quizEngineProvider).submitAnswer(userAnswer);
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            // Skip Button
            const SizedBox(height: 40),
            Consumer(
              builder: (context, ref, child) {
                final canSkip = ref.watch(canSkipFlagProvider);
                return // Skip Button
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppColors.secondaryColor)),
                        onPressed: canSkip.value ?? false
                            ? () {
                                ref.read(quizEngineProvider).skipQuestion();
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('🏃🏻‍♂️', style: TextStyle(fontSize: 40)),
                            SizedBox(width: 8),
                            Text(
                              'Skip       ',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
