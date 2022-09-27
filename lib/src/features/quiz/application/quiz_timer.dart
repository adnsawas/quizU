import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/utils/in_memory_store.dart';

class QuizTimer {
  QuizTimer({this.duration = const Duration(seconds: 120)})
      : remainingTimeInSeconds = InMemoryStore<int>(duration.inSeconds);
  final Duration duration;

  late Timer _timer;

  /// The [finishTime] is required to overcome the issue when app becomes in
  /// background, this actually causes the timer to stop
  /// so we calculate the [finishTime] when timer starts and then recalculate
  /// [remainingTimeInSeconds] with every tick
  late DateTime finishTime;
  final InMemoryStore<int> remainingTimeInSeconds;

  void startTimer() {
    finishTime = DateTime.now().add(duration);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingTimeInSeconds.value =
          finishTime.difference(DateTime.now()).inSeconds;
      if (remainingTimeInSeconds.value < 0) {
        _timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer.cancel();
  }
}

final quizTimerProvider = Provider.autoDispose<QuizTimer>((ref) {
  return QuizTimer(duration: const Duration(seconds: 15));
});

final remainingTimeInSecondsStreamProvider =
    StreamProvider.autoDispose<int>((ref) {
  final quizTimer = ref.watch(quizTimerProvider);
  return quizTimer.remainingTimeInSeconds.stream;
});
