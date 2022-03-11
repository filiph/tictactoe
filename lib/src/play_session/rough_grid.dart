import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/style/colors.dart';

class RoughGrid extends StatelessWidget {
  final int width;
  final int height;

  const RoughGrid(this.width, this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Stack(
      fit: StackFit.expand,
      children: [
        // First, "draw" (reveal) the horizontal lines
        TweenAnimationBuilder(
          // The tween start's with a negative number to achieve
          // a bit of delay before drawing. This is quite dirty, so maybe
          // optimize later?
          tween: Tween<double>(begin: -0.5, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _RoughGridPainter(
                width,
                height,
                lineColor: palette.ink,
                paintOnly: Axis.horizontal,
              ),
            ),
          ),
          builder: (BuildContext context, double progress, Widget? child) {
            return ShaderMask(
              // BlendMode.dstIn means that opacity of the linear
              // gradient below will be applied to the child (the horizontal
              // lines).
              blendMode: BlendMode.dstIn,
              shaderCallback: (Rect bounds) {
                // A linear gradient that sweeps from
                // "top-slightly-left-off-center" to
                // "bottom-slightly-right-of-center". This achieves the
                // quick "drawing" of the lines.
                return LinearGradient(
                  begin: Alignment(-0.1, -1),
                  end: Alignment(0.1, 1),
                  colors: [
                    Colors.black,
                    Colors.white.withOpacity(0),
                  ],
                  stops: [
                    progress,
                    progress + 0.05,
                  ],
                ).createShader(bounds);
              },
              child: child!,
            );
          },
        ),
        // Same as above, but for vertical lines.
        TweenAnimationBuilder(
          // Wait even longer before starting.
          tween: Tween<double>(begin: -1, end: 1),
          // Take longer to draw.
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOut,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _RoughGridPainter(
                width,
                height,
                lineColor: palette.ink,
                paintOnly: Axis.vertical,
              ),
            ),
          ),
          builder: (BuildContext context, double progress, Widget? child) {
            return ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment(-1, -0.1),
                  end: Alignment(1, 0.1),
                  colors: [
                    Colors.black,
                    Colors.white.withOpacity(0),
                  ],
                  stops: [
                    progress,
                    progress + 0.05,
                  ],
                ).createShader(bounds);
              },
              child: child!,
            );
          },
        ),
      ],
    );
  }
}

class _RoughGridPainter extends CustomPainter {
  final int width;
  final int height;

  final Color lineColor;

  final Axis? paintOnly;

  late final Paint pathPaint = Paint()
    ..colorFilter = ColorFilter.mode(lineColor, BlendMode.srcIn)
    ..strokeCap = StrokeCap.round;

  final Random _random = Random();

  _RoughGridPainter(
    this.width,
    this.height, {
    this.lineColor = Colors.black,
    this.paintOnly,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 10.0;
    const maxCrossDisplacement = 1.5;

    const gridLineThicknessRatio = 0.07;
    final lineThickness =
        size.longestSide / max(width, height) * gridLineThicknessRatio;

    final widthStep = size.width / width;

    // Draw vertical lines.
    if (paintOnly == null || paintOnly == Axis.vertical) {
      for (var i = 1; i < width; i++) {
        _roughLine(
          canvas: canvas,
          start: Offset(i * widthStep, padding),
          direction: Axis.vertical,
          length: size.height - 2 * padding,
          maxLineThickness: lineThickness,
          maxCrossAxisDisplacement: maxCrossDisplacement,
          paint: pathPaint,
          random: _random,
        );
      }
    }

    // Draw horizontal lines.
    final heightStep = size.height / height;
    if (paintOnly == null || paintOnly == Axis.horizontal) {
      for (var i = 1; i < height; i++) {
        _roughLine(
          canvas: canvas,
          start: Offset(padding, i * heightStep),
          direction: Axis.horizontal,
          length: size.width - 2 * padding,
          maxLineThickness: lineThickness,
          maxCrossAxisDisplacement: maxCrossDisplacement,
          paint: pathPaint,
          random: _random,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_RoughGridPainter oldDelegate) {
    return false; // TODO: check
  }

  static void _roughLine({
    required Canvas canvas,
    required Offset start,
    required Axis direction,
    required double length,
    required double maxLineThickness,
    required double maxCrossAxisDisplacement,
    required Paint paint,
    Random? random,
  }) {
    const segmentLength = 50.0;
    const brushCount = 7;

    final Offset straightSegment;
    final Offset end;
    if (direction == Axis.horizontal) {
      straightSegment = Offset(segmentLength, 0);
      end = start + Offset(length, 0);
    } else {
      straightSegment = Offset(0, segmentLength);
      end = start + Offset(0, length);
    }

    final _random = random ?? Random();
    var angle = _random.nextDouble() * 2 * pi;
    final angleChange = 0.3 + 0.4 * _random.nextDouble();

    final brushOffsets = List.generate(brushCount, (index) {
      var angle = _random.nextDouble() * 2 * pi;
      return Offset.fromDirection(
          angle, _random.nextDouble() * maxLineThickness / 2);
    });

    var straightPoint = start;
    var fuzzyPoint = start;

    for (var i = 0; straightPoint != end; i++) {
      angle += angleChange;

      var nextStraightPoint = straightPoint + straightSegment;
      if ((nextStraightPoint - start).distance >= length) {
        nextStraightPoint = end;
      }

      final fuzziness = Offset.fromDirection(angle, maxCrossAxisDisplacement);
      final nextFuzzyPoint = straightPoint + straightSegment + fuzziness;

      for (final brushOffset in brushOffsets) {
        paint.strokeWidth = (0.9 + 0.1 * _random.nextDouble()) *
            maxLineThickness /
            brushCount *
            1.5;
        canvas.drawLine(
            fuzzyPoint + brushOffset, nextFuzzyPoint + brushOffset, paint);
      }

      straightPoint = nextStraightPoint;
      fuzzyPoint = nextFuzzyPoint;
    }
  }
}
