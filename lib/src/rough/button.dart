import 'package:flutter/material.dart';
import 'package:rough/rough.dart';

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
    return RepaintBoundary(
      child: CustomPaint(
        painter: _RoughButtonPainter(
          borderColor: onTap != null ? Colors.red : Colors.grey,
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 34,
              vertical: 18,
            ),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 26,
                color: Colors.black,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoughButtonPainter extends CustomPainter {
  //ZigZagFiller(myFillerConfig);

  final Color borderColor;

  late final Paint pathPaint = Paint()
    ..color = borderColor
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5;

  final Paint fillPaint = Paint()
    ..color = Colors.red.withOpacity(0.5)
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..strokeWidth = 3;

  _RoughButtonPainter({this.borderColor = Colors.yellow});

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

    Drawable figure = generator.rectangle(size.width * 0.1, size.height * 0.2,
        size.width * 0.8, size.height * 0.6);
    canvas.drawRough(figure, pathPaint, fillPaint);
  }

  @override
  bool shouldRepaint(_RoughButtonPainter oldDelegate) {
    return false; // TODO: check
  }
}
