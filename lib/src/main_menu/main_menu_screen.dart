import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/style/rough/button.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Transform.rotate(
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
            const Spacer(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoughButton(
                  onTap: () => GoRouter.of(context).go('/settings'),
                  child: const Text('Settings'),
                ),
                IconButton(
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
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
