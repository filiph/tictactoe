import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/audio/sounds.dart';
import 'package:tictactoe/src/games_services/games_services.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/style/delayed_appear.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();

    return Scaffold(
      backgroundColor: palette.redPen,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        squarishMainArea: DelayedAppear(
          ms: 1000,
          child: Center(
            child: Transform.scale(
              scale: 1.2,
              child: Image.asset(
                'assets/images/main-menu.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DelayedAppear(
              ms: 800,
              child: RoughButton(
                onTap: () {
                  GoRouter.of(context).go('/play');
                },
                drawRectangle: true,
                textColor: palette.redPen,
                fontSize: 42,
                soundEffect: SfxType.erase,
                child: const Text('Play'),
              ),
            ),
            if (gamesServicesController != null) ...[
              _hideUntilReady(
                ready: gamesServicesController.signedIn,
                // TODO: show an "active" animation on the button
                child: DelayedAppear(
                  ms: 600,
                  child: RoughButton(
                    onTap: () => gamesServicesController.showAchievements(),
                    child: const Text('Achievements'),
                  ),
                ),
              ),
              _hideUntilReady(
                // TODO: show an "active" animation on the button
                ready: gamesServicesController.signedIn,
                child: DelayedAppear(
                  ms: 400,
                  child: RoughButton(
                    onTap: () => gamesServicesController.showLeaderboard(),
                    child: const Text('Leaderboard'),
                  ),
                ),
              ),
            ],
            DelayedAppear(
              ms: 200,
              child: RoughButton(
                onTap: () => GoRouter.of(context).go('/settings'),
                child: const Text('Settings'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleMuted(),
                    icon: Icon(
                      muted ? Icons.volume_off : Icons.volume_up,
                      color: palette.trueWhite,
                    ),
                  );
                },
              ),
            ),
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
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: snapshot.hasData ? 1 : 0,
          child: child,
        );
      },
    );
  }
}
