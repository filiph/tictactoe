import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/style/colors.dart';

class WarningBanner extends StatelessWidget {
  final String message;

  const WarningBanner(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Container(
      color: palette.redPen,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: palette.background),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
