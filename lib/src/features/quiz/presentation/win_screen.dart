import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_u/src/features/quiz/application/quiz_engine.dart';
import 'package:quiz_u/src/routing/router.dart';
import 'package:share_plus/share_plus.dart';

class WinScreen extends ConsumerStatefulWidget {
  const WinScreen({super.key});

  @override
  ConsumerState<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends ConsumerState<WinScreen> {
  bool startAnimation = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => startAnimation = true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final score = ref.watch(quizEngineProvider).answeredQuestions.length;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                reverseDuration: const Duration(milliseconds: 200),
                switchInCurve: Curves.elasticOut,
                switchOutCurve: Curves.ease,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: !startAnimation
                    ? const SizedBox.shrink()
                    : const Text(
                        '🏅',
                        style: TextStyle(fontSize: 120),
                      ),
              ),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          reverseDuration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.elasticOut,
                          switchOutCurve: Curves.ease,
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                          child: !startAnimation
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Text('Your final score is',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4),
                                  ],
                                )),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          reverseDuration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.elasticOut,
                          switchOutCurve: Curves.ease,
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                          child: !startAnimation
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.yellow[600],
                                    radius: 60,
                                    child: Text(
                                      '$score',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        context.goNamed(AppRoute.home.name);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.home_rounded),
                          SizedBox(width: 8),
                          Text('Home'),
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () {
                        /// `As per share_plus plugin documentation,
                        /// share_plus requires iPad users to provide the
                        /// [sharePositionOrigin] parameter.
                        /// Without it, share_plus will not work on iPads and may
                        /// cause a crash or letting the UI not responding.
                        /// To avoid that problem, provide the [sharePositionOrigin]
                        final box = context.findRenderObject() as RenderBox?;
                        Share.share(
                            'I answered $score correct answers in QuizU!',
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.ios_share_rounded),
                          SizedBox(width: 8),
                          Text('Share'),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
