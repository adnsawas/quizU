import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_u/src/routing/router.dart';

class LoseScreen extends StatefulWidget {
  const LoseScreen({super.key});

  @override
  State<LoseScreen> createState() => _LoseScreenState();
}

class _LoseScreenState extends State<LoseScreen> {
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 20, bottom: 20, right: 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    reverseDuration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.elasticOut,
                    switchOutCurve: Curves.ease,
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: !startAnimation
                        ? const SizedBox(height: 120)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('😵', style: TextStyle(fontSize: 50)),
                              const SizedBox(height: 24),
                              Text('Game Over',
                                  style: Theme.of(context).textTheme.headline4),
                            ],
                          ),
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
                        context.goNamed(AppRoute.quiz.name);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.refresh_rounded),
                          SizedBox(width: 8),
                          Text('Try Again'),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
