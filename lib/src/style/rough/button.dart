import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/audio/audio_system.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/style/palette.dart';

class RoughButton extends StatelessWidget {
  final Widget child;

  final VoidCallback? onTap;

  const RoughButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  void _handleTap(BuildContext context) {
    assert(onTap != null, "Don't call _handleTap when onTap is null");

    final settings = context.read<Settings>();
    if (!settings.muted && settings.soundsOn) {
      final audioSystem = context.read<AudioSystem>();
      audioSystem.playSfx(SfxType.buttonTap);
    }

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
          Image.asset(
            'assets/images/bar1.png',
            color: palette.ink,
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 32,
              color: onTap != null ? palette.background : palette.ink,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
