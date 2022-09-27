import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/profile/data/profile_repository.dart';
import 'package:quiz_u/src/features/quiz/application/quiz_timer.dart';
import 'package:quiz_u/src/features/quiz/data/quiz_repository.dart';
import 'package:quiz_u/src/features/quiz/domain/domain.dart';
import 'package:quiz_u/src/utils/in_memory_store.dart';

enum QuizState { onProgress, win, lose }

class QuizEngine {
  QuizEngine(
      {required this.quizRepository,
      required this.quizTimer,
      required this.profileRepository}) {
    // listen to quizTimer
    quizTimer.remainingTimeInSeconds.stream.asBroadcastStream().listen((value) {
      if (value <= 0 && answeredQuestions.isNotEmpty) {
        // when timer reaches 0, make user wins
        _win();
      } else if (value <= 0) {
        _lose();
      }
    });
  }
  // Quiz engine dependencies
  final QuizRepository quizRepository;
  final ProfileRepository profileRepository;
  final QuizTimer quizTimer;

  // Quiz engine variables

  final _quizState = InMemoryStore<QuizState>(QuizState.onProgress);

  /// List of questions to be presented to user, they should by shuffled with
  /// every quiz
  late List<Question> questions;

  /// Holds the current question displayed to the user
  final currentQuestion = InMemoryStore<Question?>(null);

  /// User's progress, holds all questions correctly answered by the user
  final List<Question> answeredQuestions = [];

  /// Flag to determine whether user can skip a question or not
  final canSkip = InMemoryStore<bool>(true);

  // method to start quiz
  void startQuiz() {
    // fill [questions] (shuffled)
    questions = List.from(quizRepository.questions.value)..shuffle();
    // fill [currentQuestion]
    currentQuestion.value = questions.removeLast();
    // start timer
    quizTimer.startTimer();
  }

  // method to submit user's answer
  void submitAnswer(String answer) {
    // check if user answered correctly
    final isCorrectAnswer = answer == currentQuestion.value!.correctAnswer;
    if (isCorrectAnswer) {
      // if answered correctly, add [currentQuesiton] to [answeredQuestions]
      answeredQuestions.add(currentQuestion.value!);
      _nextQuestion();
    } else {
      _lose();
    }
  }

  void _nextQuestion() {
    // check winning condition
    if (questions.isNotEmpty) {
      // if there are still remaining questions, move to next question
      currentQuestion.value = questions.removeLast();
    } else {
      // otherwise, stop timer and let user wins
      _win();
    }
  }

  // method that allows user to skip a question
  void skipQuestion() {
    canSkip.value = false;
    _nextQuestion();
  }

  void _win() {
    quizTimer.stopTimer();
    _quizState.value = QuizState.win;
    if (answeredQuestions.isNotEmpty) {
      // submit user score through [quizRepository]
      quizRepository.submitScore(answeredQuestions.length);
      // save score locally
      profileRepository.saveUserScore(answeredQuestions.length);
    }
  }

  void _lose() {
    quizTimer.stopTimer();
    _quizState.value = QuizState.lose;
  }
}

final quizEngineProvider = Provider.autoDispose<QuizEngine>((ref) {
  final quizRepository = ref.watch(quizRepositoryProvider);
  final quizTimer = ref.watch(quizTimerProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
  ref.onDispose(
    () => quizTimer.stopTimer(),
  );
  return QuizEngine(
      quizRepository: quizRepository,
      quizTimer: quizTimer,
      profileRepository: profileRepository);
});

final currentQuestionProvider = StreamProvider.autoDispose<Question?>((ref) {
  final quizEngine = ref.watch(quizEngineProvider);
  return quizEngine.currentQuestion.stream;
});

final quizStateStreamProvider = StreamProvider.autoDispose<QuizState>((ref) {
  final quizEngine = ref.watch(quizEngineProvider);
  return quizEngine._quizState.stream;
});

final canSkipFlagProvider = StreamProvider.autoDispose<bool>((ref) {
  final quizEngine = ref.watch(quizEngineProvider);
  return quizEngine.canSkip.stream;
});
