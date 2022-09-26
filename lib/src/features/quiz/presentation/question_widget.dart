import 'package:flutter/material.dart';
import 'package:quiz_u/src/features/quiz/domain/domain.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key, required this.question, this.onAnswer});
  final Question question;
  final Function(String userAnswer)? onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          question.questionText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: question.answers.entries.map<Widget>((answer) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (onAnswer != null) {
                      onAnswer!(answer.key);
                    }
                  },
                  child: Row(
                    children: [
                      Text(answer.key.toUpperCase()),
                      Expanded(child: Center(child: Text(answer.value))),
                    ],
                  )),
            );
          }).toList(),
        ),
      ],
    );
  }
}
