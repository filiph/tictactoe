import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import 'sprite.dart';

CustomTransitionPage<T> buildTransition<T>({
  required Widget child,
  required Color color,
  bool flipHorizontally = false,
  String? name,
  Object? arguments,
  String? restorationId,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _InkReveal(
        animation: animation,
        color: color,
        flipHorizontally: flipHorizontally,
        child: child,
      );
    },
    key: key,
    name: name,
    arguments: arguments,
    restorationId: restorationId,
    transitionDuration: const Duration(milliseconds: 700),
  );
}

class _InkReveal extends StatefulWidget {
  final Widget child;

  final Animation<double> animation;

  final Color color;

  final bool flipHorizontally;

  const _InkReveal({
    required this.child,
    required this.animation,
    required this.color,
    this.flipHorizontally = false,
  });

  @override
  State<_InkReveal> createState() => _InkRevealState();
}

class _InkRevealState extends State<_InkReveal> {
  static final _log = Logger('_InkRevealState');

  bool _finished = false;

  final _tween = Tween(begin: const Offset(0, -1), end: Offset.zero);

  @override
  void initState() {
    super.initState();

    widget.animation.addStatusListener(_statusListener);
  }

  @override
  void didUpdateWidget(covariant _InkReveal oldWidget) {
    if (oldWidget.animation != widget.animation) {
      oldWidget.animation.removeStatusListener(_statusListener);
      widget.animation.addStatusListener(_statusListener);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_statusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSprite(
          image: const AssetImage('assets/images/scribble_sprites.png'),
          frameWidth: 250,
          frameHeight: 541,
          frameCount: 12,
          animation: widget.animation,
          color: widget.color,
          flipHorizontally: widget.flipHorizontally,
        ),
        AnimatedOpacity(
          opacity: _finished ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: widget.child,
        ),
      ],
    );
  }

  void _statusListener(AnimationStatus status) {
    _log.fine(() => 'status: $status');
    switch (status) {
      case AnimationStatus.completed:
        setState(() {
          _finished = true;
        });
        break;
      case AnimationStatus.forward:
      case AnimationStatus.dismissed:
      case AnimationStatus.reverse:
        setState(() {
          _finished = false;
        });
        break;
    }
  }
}
