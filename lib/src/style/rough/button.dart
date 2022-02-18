import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/style/colors.dart';
import 'package:provider/provider.dart';

class RoughButton extends StatelessWidget {
  final Widget child;

  final VoidCallback? onTap;

  const RoughButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 34,
          vertical: 18,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Permanent Marker',
            fontSize: 26,
            color: onTap != null ? palette.darkPen : palette.ink,
          ),
          child: child,
        ),
      ),
    );
  }
}
