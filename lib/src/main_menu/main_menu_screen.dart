import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_sample/flavors.dart';
import 'package:flutter_game_sample/src/style/responsive_screen.dart';
import 'package:flutter_game_sample/src/style/rough/button.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 20);

    return Scaffold(
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: const Text(
              'Flutter Game Sample!',
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
            RoughButton(
              onTap: () {
                GoRouter.of(context).go('/play');
              },
              child: const Text('Play'),
            ),
            RoughButton(
              onTap: () => GoRouter.of(context).go('/achievements'),
              child: const Text('Achievements'),
            ),
            RoughButton(
              onTap: () => GoRouter.of(context).go('/settings'),
              child: const Text('Settings'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: IconButton(
                onPressed: () {
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(
                        content: Text('NOT IMPLEMENTED. No sound yet. '
                            'This will be a "quick mute" button that stops '
                            'both music and sounds. Many mobile players don’t '
                            'appreciate having to dig in settings to prevent '
                            'the game from blasting music.')),
                  );
                },
                icon: Icon(
                  (defaultTargetPlatform == TargetPlatform.iOS ||
                          defaultTargetPlatform == TargetPlatform.macOS)
                      ? CupertinoIcons.volume_off
                      : Icons.volume_off,
                ),
              ),
            ),
            gap,
          ],
        ),
      ),
    );
  }
}
