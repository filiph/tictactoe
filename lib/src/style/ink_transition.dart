import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/style/sprite.dart';

class InkTransitionPage<T> extends CustomTransitionPage<T> {
  const InkTransitionPage({
    required Widget child,
    String? name,
    Object? arguments,
    String? restorationId,
    LocalKey? key,
  }) : super(
          child: child,
          transitionsBuilder: _inkTransition,
          key: key,
          name: name,
          arguments: arguments,
          restorationId: restorationId,
          transitionDuration: const Duration(milliseconds: 700),
        );

  static Widget _inkTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    final palette = context.watch<Palette>();

    return _InkReveal(
      animation: animation,
      color: palette.background,
      child: child,
    );
  }
}

class _InkReveal extends StatefulWidget {
  final Widget child;

  final Animation<double> animation;

  final Color color;

  const _InkReveal({
    required this.child,
    required this.animation,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<_InkReveal> createState() => _InkRevealState();
}

class _InkRevealState extends State<_InkReveal> {
  static final _log = Logger('_InkRevealState');

  bool _finished = false;

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
          image: AssetImage('assets/images/scribble_sprites.png'),
          frameWidth: 250,
          frameHeight: 541,
          frameCount: 5,
          animation: widget.animation,
          color: widget.color,
        ),
        Visibility(
          visible: _finished,
          maintainState: true,
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
