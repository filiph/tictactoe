import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/style/colors.dart';
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

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (!animation.isCompleted) {
          return AnimatedSprite(
            image: AssetImage('assets/images/scribble_sprites.png'),
            frameWidth: 250,
            frameHeight: 541,
            frameCount: 5,
            animation: animation,
            color: palette.background,
          );
        }
        return Container(
          color: palette.background,
          child: child!,
        );
      },
      child: child,
    );
  }
}
