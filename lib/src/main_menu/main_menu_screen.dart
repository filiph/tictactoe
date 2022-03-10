import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/style/colors.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';
import 'package:tictactoe/src/style/warning_banner.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 20);
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.background,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        topMessageArea: Center(
          child: WarningBanner(
              'What to test at this point? Just general flow, crashes.'),
        ),
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: const Text(
              'Tic Tac Toe Puzzle Game!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (flavor == Flavor.lite) ...[
              Text('‘Lite’ version (for the web)'),
            ],
            gap,
            Expanded(
              child: RoughButton(
                onTap: () {
                  GoRouter.of(context).go('/play');
                },
                child: const Text('Play'),
              ),
            ),
            Expanded(
              child: RoughButton(
                onTap: () => GoRouter.of(context).go('/achievements'),
                child: const Text('Achievements'),
              ),
            ),
            Expanded(
              child: RoughButton(
                onTap: () => GoRouter.of(context).go('/settings'),
                child: const Text('Settings'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Selector<Settings, bool>(
                selector: (context, settings) => settings.muted,
                builder: (context, muted, child) {
                  IconData icon;
                  if (muted) {
                    icon = (defaultTargetPlatform == TargetPlatform.iOS ||
                            defaultTargetPlatform == TargetPlatform.macOS)
                        ? CupertinoIcons.volume_off
                        : Icons.volume_off;
                  } else {
                    icon = (defaultTargetPlatform == TargetPlatform.iOS ||
                            defaultTargetPlatform == TargetPlatform.macOS)
                        ? CupertinoIcons.volume_up
                        : Icons.volume_up;
                  }

                  return IconButton(
                    onPressed: () {
                      context.read<Settings>().toggleMuted();
                    },
                    icon: Icon(icon),
                  );
                },
              ),
            ),
            gap,
          ],
        ),
      ),
    );
  }
}
