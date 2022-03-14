import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/style/colors.dart';

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
          transitionDuration: const Duration(milliseconds: 500),
        );

  static Widget _inkTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (!animation.isCompleted) {
          return _InkScribble(animation);
        }
        return child!;
      },
      child: child,
    );
  }
}

class _InkScribble extends AnimatedWidget {
  const _InkScribble(Listenable listenable) : super(listenable: listenable);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    const max = 15;
    final palette = context.watch<Palette>();
    final current = (_progress.value * max).round();

    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i <= max; i++)
          Visibility(
            key: ValueKey(i),
            visible: i == current,
            child: Image.asset(
              'assets/images/ink${i.toString().padLeft(2, '0')}.png',
              fit: BoxFit.cover,
              color: palette.background,
            ),
          )
      ],
    );
  }
}
