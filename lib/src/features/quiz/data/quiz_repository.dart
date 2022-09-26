import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/quiz/domain/domain.dart';
import 'package:quiz_u/src/utils/api_end_points.dart';
import 'package:quiz_u/src/utils/app_http_client.dart';
import 'package:quiz_u/src/utils/in_memory_store.dart';

class QuizRepository {
  QuizRepository(this.client);
  final AppHttpClient client;

  final questions = InMemoryStore<List<Question>>([]);

  Future<void> fetchQuestions() async {
    try {
      final response = await client.get(Uri.parse(Endpoints.questions));
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final questions = responseJson
            .map<Question>((question) => Question.fromJson(question))
            .toList();
        this.questions.value = questions;
      } else {
        throw 'Could not fetch quiz questions';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> submitScore(int score) async {
    try {
      final response = await client.post(Uri.parse(Endpoints.submitScore),
          body: {'score': score.toString()});
      if (response.statusCode == 201) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['success']) {
          // when score is submitted successfully, nothing needs to be done
        } else {
          throw responseJson['message'] ??
              'Error while submitting user\'s score';
        }
      } else {
        throw 'Error while submitting user\'s score';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final client = ref.watch(appHttpClientProvider);
  return QuizRepository(client);
});

final questionsStreamProvider =
    StreamProvider.autoDispose<List<Question>>((ref) {
  final quizRepository = ref.watch(quizRepositoryProvider)..fetchQuestions();
  return quizRepository.questions.stream;
}, cacheTime: const Duration(seconds: 120));
