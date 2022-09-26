import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_u/src/routing/router.dart';
import 'package:quiz_u/src/theme/app_colors.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, required this.child});

  final Widget child;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _getCurrentIndex(context),
        onTap: (value) {
          switch (value) {
            case 0:
              context.goNamed(AppRoute.home.name);
              break;
            case 1:
              context.goNamed(AppRoute.leaderboard.name);
              break;
            case 2:
              context.goNamed(AppRoute.profile.name);
          }
        },
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouter.of(context).location;
    if (location.contains(AppRoute.home.name)) {
      return 0;
    } else if (location.contains(AppRoute.leaderboard.name)) {
      return 1;
    } else if (location.contains(AppRoute.profile.name)) {
      return 2;
    } else {
      return 0;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
