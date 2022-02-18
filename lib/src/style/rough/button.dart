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

    return InkResponse(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            'assets/images/bar1.png',
            color: palette.ink,
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 32,
              color: onTap != null ? palette.background : palette.ink,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
