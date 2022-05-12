import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/audio/audio_controller.dart';
import 'package:tictactoe/src/audio/sounds.dart';
import 'package:tictactoe/src/style/palette.dart';

class RoughButton extends StatelessWidget {
  final Widget child;

  final VoidCallback? onTap;

  final Color? textColor;

  final bool drawRectangle;

  final double fontSize;

  final SfxType soundEffect;

  const RoughButton({
    super.key,
    required this.child,
    required this.onTap,
    this.textColor,
    this.fontSize = 32,
    this.drawRectangle = false,
    this.soundEffect = SfxType.buttonTap,
  });

  void _handleTap(BuildContext context) {
    assert(onTap != null, "Don't call _handleTap when onTap is null");

    final audioController = context.read<AudioController>();
    audioController.playSfx(soundEffect);

    onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return InkResponse(
      onTap: onTap == null ? null : () => _handleTap(context),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (drawRectangle)
            Image.asset(
              'assets/images/bar.png',
            ),
          DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: fontSize,
              color: onTap != null ? textColor : palette.ink,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _RoughBox extends StatefulWidget {
  final ImageProvider image = const AssetImage('assets/images/box.png');

  const _RoughBox({Key? key}) : super(key: key);

  @override
  State<_RoughBox> createState() => _RoughBoxState();
}

class _RoughBoxState extends State<_RoughBox> {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;

  @override
  Widget build(BuildContext context) {
    ui.Image? img = _imageInfo?.image;
    if (img == null) {
      return const SizedBox();
    }
    // int w = img.width;
    // int frame = widget.frame;
    // int frameW = widget.frameWidth;
    // int frameH = widget.frameHeight;
    // int cols = (w / frameW).floor();
    // int col = frame % cols;
    // int row = (frame / cols).floor();
    // ui.Rect rect = ui.Rect.fromLTWH(
    //     col * frameW * 1.0, row * frameH * 1.0, frameW * 1.0, frameH * 1.0);
    return CustomPaint(painter: _RoughBoxPainter(img));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImage();
  }

  @override
  void didUpdateWidget(_RoughBox oldWidget) {
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

class _RoughBoxPainter extends CustomPainter {
  ui.Image image;

  _RoughBoxPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: image,
      centerSlice: const Rect.fromLTRB(5, 5, 5, 5),
      fit: BoxFit.fitWidth,
    );
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
  }

  @override
  bool shouldRepaint(_RoughBoxPainter oldDelegate) {
    return oldDelegate.image != image;
  }
}
