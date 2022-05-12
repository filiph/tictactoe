/// This code taken from  https://github.com/gskinnerTeam/flutter_vignettes
/// (the `_shared` directory) with slight modifications.
library sprite;

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// Takes an [image] representation of a sprite sheet, with
/// [frameWidth]x[frameHeight]-sized sprites. Then animates it in sequence
/// from left to right and top to bottom.
///
/// Example usage:
///
/// ```
/// AnimatedSprite(
///   image: AssetImage('...'),
///   frameWidth: 360,
///   frameHeight: 720,
///   frameCount: 42,
///   animation: _animation,
/// );
/// ```
class AnimatedSprite extends AnimatedWidget {
  final ImageProvider image;
  final int frameWidth;
  final int frameHeight;
  final int frameStart;
  final int frameCount;

  final Color? color;
  final bool flipHorizontally;

  const AnimatedSprite({
    required this.image,
    required this.frameWidth,
    required this.frameCount,
    required Animation<double> animation,
    required this.frameHeight,
    this.frameStart = 0,
    this.flipHorizontally = false,
    this.color,
    super.key,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Sprite(
      image: image,
      frameWidth: frameWidth,
      frameHeight: frameHeight,
      frame: frameStart + (animation.value * frameCount).floor(),
      color: color,
      flipHorizontally: flipHorizontally,
    );
  }
}

class Sprite extends StatefulWidget {
  final ImageProvider image;
  final int frameWidth;
  final int frameHeight;
  final int frame;

  final Color? color;
  final bool flipHorizontally;

  const Sprite({
    required this.image,
    required this.frameWidth,
    required this.frameHeight,
    this.color,
    this.flipHorizontally = false,
    this.frame = 0,
    super.key,
  });

  @override
  State<Sprite> createState() => _SpriteState();
}

class _SpritePainter extends CustomPainter {
  final ui.Image image;
  final ui.Rect rect;

  final Color? color;
  final bool flipHorizontally;

  final Paint _paint = Paint();

  _SpritePainter(this.image, this.rect, this.color, this.flipHorizontally) {
    if (color != null) {
      _paint.colorFilter = ui.ColorFilter.mode(color!, BlendMode.srcIn);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (flipHorizontally) {
      final double dx = -(size.width / 2.0);
      canvas.translate(-dx, 0.0);
      canvas.scale(-1.0, 1.0);
      canvas.translate(dx, 0.0);
    }
    canvas.drawImageRect(image, rect,
        ui.Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
  }

  @override
  bool shouldRepaint(_SpritePainter oldPainter) {
    return oldPainter.image != image || oldPainter.rect != rect;
  }
}

class _SpriteState extends State<Sprite> {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;

  @override
  Widget build(BuildContext context) {
    ui.Image? img = _imageInfo?.image;
    if (img == null) {
      return const SizedBox();
    }
    int w = img.width;
    int frame = widget.frame;
    int frameW = widget.frameWidth;
    int frameH = widget.frameHeight;
    int cols = (w / frameW).floor();
    int col = frame % cols;
    int row = (frame / cols).floor();
    ui.Rect rect = ui.Rect.fromLTWH(
        col * frameW * 1.0, row * frameH * 1.0, frameW * 1.0, frameH * 1.0);
    return CustomPaint(
        painter:
            _SpritePainter(img, rect, widget.color, widget.flipHorizontally));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImage();
  }

  @override
  void didUpdateWidget(Sprite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _getImage();
    }
  }

  @override
  void dispose() {
    _imageStream?.removeListener(ImageStreamListener(_updateImage));
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _getImage() {
    final ImageStream? oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    if (_imageStream!.key == oldImageStream?.key) {
      return;
    }
    final ImageStreamListener listener = ImageStreamListener(_updateImage);
    oldImageStream?.removeListener(listener);
    _imageStream!.addListener(listener);
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _imageInfo = imageInfo;
    });
  }
}
