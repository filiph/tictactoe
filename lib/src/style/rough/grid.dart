import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game_sample/src/style/colors.dart';
import 'package:provider/provider.dart';

Future<ui.Image> loadUiImage(String imageAssetPath) async {
  final ByteData data = await rootBundle.load(imageAssetPath);
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}

class RoughGrid extends StatelessWidget {
  final int width;
  final int height;

  const RoughGrid(this.width, this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_Tuple<ui.Image>>(
      future: _Tuple.combine(
        loadUiImage('assets/images/horizontal.png'),
        loadUiImage('assets/images/vertical.png'),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        final palette = context.watch<Palette>();

        return RepaintBoundary(
          child: CustomPaint(
            painter: _RoughGridPainter(
              width,
              height,
              lineColor: palette.ink,
              horizontal: snapshot.data!.a,
              vertical: snapshot.data!.b,
            ),
          ),
        );
      },
    );
  }
}

class _RoughGridPainter extends CustomPainter {
  final int width;
  final int height;

  final Color lineColor;

  late final Paint pathPaint = Paint()
    ..colorFilter = ColorFilter.mode(lineColor, BlendMode.srcIn);

  final ui.Image vertical;

  final ui.Image horizontal;

  final Random _random = Random();

  _RoughGridPainter(
    this.width,
    this.height, {
    required this.vertical,
    required this.horizontal,
    this.lineColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 10.0;
    const maxCrossDisplacement = 1.0;

    const gridLineThicknessRatio = 0.1;
    final lineThickness =
        size.longestSide / max(width, height) * gridLineThicknessRatio;

    final widthStep = size.width / width;

    // Draw vertical lines.
    final verticalScale = (size.height - padding) / vertical.height;
    for (var i = 1; i < width; i++) {
      canvas.drawPicture(
        _roughLine(
          vertical,
          Offset(i * widthStep, padding),
          maxCrossDisplacement,
          pathPaint,
          mainAxisScale: verticalScale,
          lineThickness: lineThickness,
          directionIsVertical: true,
          random: _random,
        ),
      );
    }

    // Draw horizontal lines.
    final heightStep = size.height / height;
    final horizontalScale = (size.width - padding) / horizontal.width;
    for (var i = 1; i < height; i++) {
      canvas.drawPicture(
        _roughLine(
          horizontal,
          Offset(padding, i * heightStep),
          maxCrossDisplacement,
          pathPaint,
          mainAxisScale: horizontalScale,
          lineThickness: lineThickness,
          directionIsVertical: false,
          random: _random,
        ),
      );
      // canvas.drawImageNine(
      //   horizontal,
      //   Rect.fromLTRB(15, 15, 15, 15),
      //   Rect.fromLTWH(padding, i * heightStep - lineWidth / 2,
      //       size.width - padding, lineWidth),
      //   pathPaint,
      // );
    }
  }

  @override
  bool shouldRepaint(_RoughGridPainter oldDelegate) {
    return false; // TODO: check
  }

  static ui.Picture _roughLine(
    ui.Image image,
    Offset position,
    double maxCrossAxisDisplacement,
    Paint paint, {
    required directionIsVertical,
    required double lineThickness,
    Random? random,
    double mainAxisScale = 1.0,
  }) {
    final _random = random ?? Random();

    var pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);

    const maxSkew = 0.05;
    const skewDamping = 0.2;
    const segmentLength = 100.0;
    final outputSegmentLength = segmentLength * mainAxisScale;

    final length = directionIsVertical ? image.height : image.width;

    var totalCrossAxisDisplacement = 0.0;
    canvas.translate(position.dx, position.dy);
    var skew = _random.nextDouble() * maxSkew - (maxSkew / 2);
    canvas.save();
    for (var segmentStart = 0.0;
        segmentStart < length;
        segmentStart += segmentLength) {
      skew = skewDamping * skew +
          (1 - skewDamping) * (_random.nextDouble() * maxSkew - (maxSkew / 2));
      if (totalCrossAxisDisplacement > maxCrossAxisDisplacement) {
        skew = -skew.abs();
      } else if (totalCrossAxisDisplacement < -maxCrossAxisDisplacement) {
        skew = skew.abs();
      }
      final crossAxisDisplacement = skew * segmentLength;
      totalCrossAxisDisplacement += crossAxisDisplacement;

      canvas.save();
      if (directionIsVertical) {
        canvas.skew(skew, 0);
        canvas.drawImageRect(
            image,
            Rect.fromLTWH(
                0, segmentStart, image.width.toDouble(), segmentLength),
            Rect.fromPoints(Offset(-lineThickness / 2, 0),
                Offset(lineThickness / 2, outputSegmentLength)),
            paint);
      } else {
        canvas.skew(0, skew);
        canvas.drawImageRect(
            image,
            Rect.fromLTWH(
                segmentStart, 0, segmentLength, image.height.toDouble()),
            Rect.fromPoints(Offset(0, -lineThickness / 2),
                Offset(outputSegmentLength, lineThickness / 2)),
            paint);
      }
      canvas.restore();
      if (directionIsVertical) {
        canvas.translate(crossAxisDisplacement, outputSegmentLength);
      } else {
        canvas.translate(outputSegmentLength, crossAxisDisplacement);
      }
    }
    canvas.restore();

    return pictureRecorder.endRecording();
  }
}

class _Tuple<T> {
  final T a;
  final T b;

  _Tuple(this.a, this.b);

  static Future<_Tuple<T>> combine<T>(Future<T> a, Future<T> b) async {
    final results = await Future.wait([a, b]);
    return _Tuple(results[0], results[1]);
  }
}
