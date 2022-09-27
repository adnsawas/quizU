import 'package:flutter/material.dart';

class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
    animation = Tween<double>(begin: 0.5, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
