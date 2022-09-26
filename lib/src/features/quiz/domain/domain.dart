// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class Question {
  Question(
      {required this.questionText,
      required this.answers,
      required this.correctAnswer});
  final String questionText;
  final Map<String, String> answers;
  final String correctAnswer;

  factory Question.fromJson(Map<String, dynamic> map) {
    // Get all answers
    final answers = <String, String>{};
    answers['a'] = map['a'];
    answers['b'] = map['b'];
    answers['c'] = map['c'];
    answers['d'] = map['d'];
    return Question(
      questionText: map['Question'] as String,
      answers: answers,
      correctAnswer: map['correct'],
    );
  }

  @override
  bool operator ==(covariant Question other) {
    if (identical(this, other)) return true;

    return other.questionText == questionText &&
        mapEquals(other.answers, answers) &&
        other.correctAnswer == correctAnswer;
  }

  @override
  int get hashCode =>
      questionText.hashCode ^ answers.hashCode ^ correctAnswer.hashCode;
}
