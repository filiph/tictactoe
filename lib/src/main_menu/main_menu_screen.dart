import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/audio/sounds.dart';
import 'package:tictactoe/src/games_services/games_services.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 20);

    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
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
          children: [
            if (flavor == Flavor.lite) ...[
              Text('‘Lite’ version (for the web)'),
            ],
            gap,
            Expanded(
              flex: 2,
              child: RoughButton(
                onTap: () {
                  GoRouter.of(context).go('/play');
                },
                child: const Text('Play'),
                drawRectangle: true,
                color: palette.redPen,
                fontSize: 42,
                soundEffect: SfxType.erase,
              ),
            ),
            if (platformSupportsGamesServices) ...[
              Expanded(
                child: _hideUntilReady(
                  ready: gamesServicesController.signedIn,
                  child: RoughButton(
                    onTap: () => gamesServicesController.showAchievements(),
                    child: const Text('Achievements'),
                  ),
                ),
              ),
              Expanded(
                child: _hideUntilReady(
                  ready: gamesServicesController.signedIn,
                  child: RoughButton(
                    onTap: () => gamesServicesController.showLeaderboard(),
                    child: const Text('Leaderboard'),
                  ),
                ),
              ),
            ],
            Expanded(
              child: RoughButton(
                onTap: () => GoRouter.of(context).go('/settings'),
                child: const Text('Settings'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Selector<SettingsController, bool>(
                selector: (context, settings) => settings.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () {
                      context.read<SettingsController>().toggleMuted();
                    },
                    icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                  );
                },
              ),
            ),
            gap,
            Text('Music by Mr Smith'),
            gap,
          ],
        ),
      ),
    );
  }

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        // Use Visibility here so that we have the space for the buttons
        // ready.
        return Visibility(
          visible: snapshot.data ?? false,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: child,
        );
      },
    );
  }
}
