import 'package:flutter/material.dart';
import 'package:rough/rough.dart';

class RoughGrid extends StatelessWidget {
  final int width;
  final int height;

  const RoughGrid(this.width, this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _RoughGridPainter(width, height, lineColor: Colors.grey),
      ),
    );
  }
}

class _RoughGridPainter extends CustomPainter {
  //ZigZagFiller(myFillerConfig);

  final int width;
  final int height;

  final Color lineColor;

  late final Paint pathPaint = Paint()
    ..color = lineColor
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5;

  final Paint fillPaint = Paint()
    ..color = Colors.red.withOpacity(0.5)
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 3;

  _RoughGridPainter(this.width, this.height, {this.lineColor = Colors.black});

  @override
  paint(Canvas canvas, Size size) {
    final DrawConfig drawConfig = DrawConfig.build(
      roughness: 3,
      seed: size.hashCode,
    );

    final FillerConfig myFillerConfig = FillerConfig.build(
      hachureGap: 6,
      hachureAngle: -20,
      drawConfig: drawConfig,
    );

    final Filler filler = NoFiller(myFillerConfig);

    final Generator generator = Generator(drawConfig, filler);

    const padding = 10.0;

    final widthStep = size.width / width;
    for (var i = 1; i < width; i++) {
      final figure = generator.line(
          i * widthStep, padding, i * widthStep, size.height - padding);
      canvas.drawRough(figure, pathPaint, fillPaint);
    }

    final heightStep = size.height / height;
    for (var i = 1; i < height; i++) {
      final figure = generator.line(
          padding, i * heightStep, size.width - padding, i * heightStep);
      canvas.drawRough(figure, pathPaint, fillPaint);
    }
  }

  @override
  bool shouldRepaint(_RoughGridPainter oldDelegate) {
    return false; // TODO: check
  }
}
