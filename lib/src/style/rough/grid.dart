import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          return Placeholder();
        }

        return CustomPaint(
          painter: _RoughGridPainter(
            width,
            height,
            lineColor: Colors.grey,
            horizontal: snapshot.data!.a,
            vertical: snapshot.data!.b,
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
    ..color = lineColor
    ..colorFilter = ColorFilter.mode(Colors.black54, BlendMode.srcIn);

  final ui.Image vertical;

  final ui.Image horizontal;

  _RoughGridPainter(
    this.width,
    this.height, {
    required this.vertical,
    required this.horizontal,
    this.lineColor = Colors.black,
  });

  @override
  paint(Canvas canvas, Size size) {
    const padding = 10.0;

    final widthStep = size.width / width;
    final lineWidth = widthStep / 10;
    for (var i = 1; i < width; i++) {
      // TODO: draw with smaller segments and make the line a bit less straight
      canvas.drawImageNine(
        vertical,
        Rect.fromLTRB(15, 15, 15, 15),
        Rect.fromLTWH(i * widthStep - lineWidth / 2, padding, lineWidth,
            size.height - padding),
        pathPaint,
      );
    }

    final heightStep = size.height / height;
    for (var i = 1; i < height; i++) {
      // TODO: draw with smaller segments and make the line a bit less straight
      canvas.drawImageNine(
        horizontal,
        Rect.fromLTRB(15, 15, 15, 15),
        Rect.fromLTWH(padding, i * heightStep - lineWidth / 2,
            size.width - padding, lineWidth),
        pathPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RoughGridPainter oldDelegate) {
    return false; // TODO: check
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
