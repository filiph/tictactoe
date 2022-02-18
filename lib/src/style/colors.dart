import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF0062A2),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFCFE5FF),
  onPrimaryContainer: Color(0xFF001D36),
  secondary: Color(0xFF006D3C),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF96F7B7),
  onSecondaryContainer: Color(0xFF00210E),
  tertiary: Color(0xFF006784),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFBAEAFF),
  onTertiaryContainer: Color(0xFF001F2A),
  error: Color(0xFFBA1B1B),
  errorContainer: Color(0xFFFFDAD4),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410001),
  background: Color(0xFFFBFDFA),
  onBackground: Color(0xFF191C1B),
  surface: Color(0xFFFBFDFA),
  onSurface: Color(0xFF191C1B),
  surfaceVariant: Color(0xFFDFE3EC),
  onSurfaceVariant: Color(0xFF42474E),
  outline: Color(0xFF72777F),
  onInverseSurface: Color(0xFFEFF1EE),
  inverseSurface: Color(0xFF2D312F),
  inversePrimary: Color(0xFF9ACBFF),
  shadow: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF9ACBFF),
  onPrimary: Color(0xFF003257),
  primaryContainer: Color(0xFF00497B),
  onPrimaryContainer: Color(0xFFCFE5FF),
  secondary: Color(0xFF7BDA9D),
  onSecondary: Color(0xFF00391C),
  secondaryContainer: Color(0xFF00522B),
  onSecondaryContainer: Color(0xFF96F7B7),
  tertiary: Color(0xFF61D4FF),
  onTertiary: Color(0xFF003546),
  tertiaryContainer: Color(0xFF004D64),
  onTertiaryContainer: Color(0xFFBAEAFF),
  error: Color(0xFFFFB4A9),
  errorContainer: Color(0xFF930006),
  onError: Color(0xFF680003),
  onErrorContainer: Color(0xFFFFDAD4),
  background: Color(0xFF191C1B),
  onBackground: Color(0xFFE1E3E0),
  surface: Color(0xFF191C1B),
  onSurface: Color(0xFFE1E3E0),
  surfaceVariant: Color(0xFF42474E),
  onSurfaceVariant: Color(0xFFC3C7CF),
  outline: Color(0xFF8C9199),
  onInverseSurface: Color(0xFF191C1B),
  inverseSurface: Color(0xFFE1E3E0),
  inversePrimary: Color(0xFF0062A2),
  shadow: Color(0xFF000000),
);

/// Colors taken from this picture of some writing on a piece of paper:
/// https://www.gouletpens.com/products/leuchtturm1917-some-lines-a-day-a5-notebook-nordic-blue
class Palette {
  final light = const Color(0xffd8f0fc);
  final pen = const Color(0xff0b8fe4);
  final darkPen = const Color(0xFF020887);
  final redPen = const Color(0xFF930006);
  final ink = const Color(0xff3a3e3a);
  final background = const Color(0xfff2f5f1);
}
