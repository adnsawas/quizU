import 'package:flutter/material.dart';

class CountDownWidget extends StatelessWidget {
  const CountDownWidget({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final minutesAsString = (seconds ~/ 60).toString();
    final secondsAsInt = seconds % 60;
    final secondsAsString =
        secondsAsInt < 10 ? '0$secondsAsInt' : '$secondsAsInt';

    final countDownValueAsString = '$minutesAsString:$secondsAsString';
    return Text(
      '$countDownValueAsString ⏳',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 40),
    );
  }
}
