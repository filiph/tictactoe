import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/style/palette.dart';

class RoughGrid extends StatelessWidget {
  final int width;
  final int height;

  const RoughGrid(this.width, this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final lineColor = palette.ink;

    return Stack(
      fit: StackFit.expand,
      children: [
        // First, "draw" (reveal) the horizontal lines
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _RoughGridPainter(
                width,
                height,
                lineColor: lineColor,
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
                  begin: const Alignment(-0.1, -1),
                  end: const Alignment(0.1, 1),
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
          // The tween start's with a negative number to achieve
          // a bit of delay before drawing. This is quite dirty, so maybe
          // optimize later?
          tween: Tween<double>(begin: -1, end: 1),
          // Take longer to draw.
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOut,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _RoughGridPainter(
                width,
                height,
                lineColor: lineColor,
                paintOnly: Axis.vertical,
              ),
            ),
          ),
          builder: (BuildContext context, double progress, Widget? child) {
            return ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: const Alignment(-1, -0.1),
                  end: const Alignment(1, 0.1),
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
    ..colorFilter = ColorFilter.mode(lineColor, BlendMode.srcIn);

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

    const gridLineThicknessRatio = 0.1;
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
    return oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.paintOnly != paintOnly ||
        oldDelegate.lineColor != lineColor;
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
      straightSegment = const Offset(segmentLength, 0);
      end = start + Offset(length, 0);
    } else {
      straightSegment = const Offset(0, segmentLength);
      end = start + Offset(0, length);
    }

    final rng = random ?? Random();
    var angle = rng.nextDouble() * 2 * pi;
    final angleChange = 0.3 + 0.4 * rng.nextDouble();

    // Generate a displacement of "strands" that constitute the whole brush.
    // Each strand will make its own line.
    final strandOffsets = List.generate(brushCount, (index) {
      var angle = rng.nextDouble() * 2 * pi;
      return Offset.fromDirection(
          angle, rng.nextDouble() * maxLineThickness / 3);
    });

    var straightPoint = start;
    final fuzziness = Offset.fromDirection(angle, maxCrossAxisDisplacement);
    var fuzzyPoint = start + fuzziness;

    for (var i = 0; straightPoint != end; i++) {
      angle += angleChange;

      var nextStraightPoint = straightPoint + straightSegment;
      if ((nextStraightPoint - start).distance >= length) {
        nextStraightPoint = end;
      }

      final fuzziness = Offset.fromDirection(angle, maxCrossAxisDisplacement);
      final nextFuzzyPoint = nextStraightPoint + fuzziness;

      if (i == 0 || nextStraightPoint == end) {
        paint.strokeCap = StrokeCap.round;
      } else {
        paint.strokeCap = StrokeCap.butt;
      }

      // Drawing individual "strands" makes the line more natural.
      for (final strandOffset in strandOffsets) {
        paint.strokeWidth =
            (0.8 + 0.4 * rng.nextDouble()) * maxLineThickness / brushCount * 2;
        canvas.drawLine(
            fuzzyPoint + strandOffset, nextFuzzyPoint + strandOffset, paint);
      }

      straightPoint = nextStraightPoint;
      fuzzyPoint = nextFuzzyPoint;
    }
  }
}
