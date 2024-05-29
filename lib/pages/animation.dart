import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_app/home_screen.dart';

class AnimatedContent extends StatefulWidget {
  final Widget child;
  final bool includeInactivityTimer;
  const AnimatedContent(
      {super.key, required this.child, this.includeInactivityTimer = true});

  @override
  _AnimatedContentState createState() => _AnimatedContentState();
}

class _AnimatedContentState extends State<AnimatedContent> {
  late Timer _inactivityTimer;

  @override
  void initState() {
    super.initState();
    if (widget.includeInactivityTimer) {
      _resetTimer();
    }
  }

  @override
  void dispose() {
    if (widget.includeInactivityTimer) {
      _inactivityTimer.cancel();
    }
    super.dispose();
  }

  void _resetTimer() {
    _inactivityTimer = Timer(const Duration(seconds: 5), () {
      // Navigate to the homepage after 30 seconds of inactivity
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    });
  }

  void _handleUserInteraction([_]) {
    if (widget.includeInactivityTimer) {
      if (_inactivityTimer.isActive) {
        _inactivityTimer.cancel();
      }
      _resetTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
