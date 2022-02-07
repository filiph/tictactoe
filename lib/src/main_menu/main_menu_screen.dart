import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/rough/button.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void showSnackDebug(String message) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(content: Text('NOT IMPLEMENTED. $message')),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.red,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Ignore the design at this point. This is a structural & '
                    'functional wireframe, basically.',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
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
              onTap: () =>
                  showSnackDebug("You haven't achieved anything yet, have you. "
                      "This is also where the leaderboard will be."),
              child: const Text('Achievements'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoughButton(
                  onTap: () => showSnackDebug(
                      'This will have settings such as language.'),
                  child: const Text('Settings'),
                ),
                IconButton(
                  onPressed: () => showSnackDebug('No sound yet.'),
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
