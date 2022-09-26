import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_u/src/features/auth/data/auth_repository.dart';
import 'package:quiz_u/src/features/auth/presentation/main_auth_screen.dart';
import 'package:quiz_u/src/features/intro/presentation/intro_screen.dart';
import 'package:quiz_u/src/features/quiz/presentation/lose_screen.dart';
import 'package:quiz_u/src/features/quiz/presentation/quiz_home_screen.dart';
import 'package:quiz_u/src/features/home/presentaion/tabs_screen.dart';
import 'package:quiz_u/src/features/leaderboard/presentation/leaderboard_screen.dart';
import 'package:quiz_u/src/features/profile/presentation/profile_screen.dart';
import 'package:quiz_u/src/features/quiz/presentation/quiz_screen.dart';
import 'package:quiz_u/src/features/quiz/presentation/win_screen.dart';
import 'package:quiz_u/src/features/splash/presentation/splash_screen.dart';
import 'package:quiz_u/src/routing/router_refresh_stream.dart';

enum AppRoute {
  splash,
  auth,
  intro,
  home,
  leaderboard,
  profile,
  quiz,
  win,
  lose,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirectLimit: 2,
      // Once authStateChanges changes, we would like to refresh the router
      refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
      redirect: (context, state) {
        final userIsLogging = state.location == '/auth' ||
            state.location == '/' ||
            state.location == '/intro';
        final userIsLoggedIn = auth.isValidUser;
        if (!userIsLogging && !userIsLoggedIn) {
          // redirect user to Login Screen
          return '/intro';
        }
        if (userIsLogging && !userIsLoggedIn) {
          // do not redirect the user
          return null;
        }
        if (!userIsLogging && userIsLoggedIn) {
          // do not redirect the user
          return null;
        }
        // if user is logging while is actually logged in
        else {
          return '/home';
        }
      },
      routes: [
        GoRoute(
          path: '/',
          name: AppRoute.splash.name,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SplashScreen()),
        ),
        GoRoute(
          path: '/auth',
          name: AppRoute.auth.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: MainAuthScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    ScaleTransition(scale: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        ),
        GoRoute(
          path: '/intro',
          name: AppRoute.intro.name,
          builder: (context, state) => IntroScreen(),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state, child) => NoTransitionPage(
              child: TabsScreen(key: state.pageKey, child: child)),
          routes: [
            GoRoute(
              path: '/home',
              name: AppRoute.home.name,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: QuizHomeScreen()),
              routes: [
                GoRoute(
                  path: 'quiz',
                  name: AppRoute.quiz.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) => const MaterialPage(
                      fullscreenDialog: true, child: QuizScreen()),
                ),
                GoRoute(
                  path: 'win',
                  name: AppRoute.win.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const WinScreen(),
                ),
                GoRoute(
                  path: 'lose',
                  name: AppRoute.lose.name,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const LoseScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/leaderboard',
              name: AppRoute.leaderboard.name,
              pageBuilder: (context, state) => NoTransitionPage(
                  child: LeaderboardScreen(
                key: state.pageKey,
              )),
            ),
            GoRoute(
              path: '/profile',
              name: AppRoute.profile.name,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen()),
            ),
          ],
        ),
      ]);
});
