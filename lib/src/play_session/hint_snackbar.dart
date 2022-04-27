import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/style/palette.dart';

void showHintSnackbar(BuildContext context) {
  final hint = hints[_currentHintIndex];
  _currentHintIndex++;
  _currentHintIndex = _currentHintIndex % hints.length;

  final palette = context.read<Palette>();
  final text = RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: 'Hint: ',
          style: TextStyle(
            color: palette.redPen,
          ),
        ),
        TextSpan(
          text: hint,
          style: TextStyle(
            color: palette.ink,
          ),
        ),
      ],
    ),
  );

  final duration = Duration(milliseconds: hint.characters.length * 120);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: text,
      margin: const EdgeInsets.only(bottom: 30, left: 24, right: 24),
      behavior: SnackBarBehavior.floating,
      duration: duration,
      backgroundColor: palette.backgroundLevelSelection,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

int _currentHintIndex = 0;

const List<String> hints = [
  'Start in the center if you can.',
  'Put Xs close to each other.',
  'Try to put Xs in places where they could be part of '
      'two different winning lines.',
  "If the opponent is in trouble, press the advantage.",
  'Always be making new opportunities.',
  "Don’t pursue lines that are already doomed "
      "(when there’s no place for a winning line there anymore)."
];
