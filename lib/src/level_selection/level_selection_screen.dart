import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/achievements/player_progress.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';
import 'package:tictactoe/src/style/warning_banner.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();
    final palette = context.watch<Palette>();

    return Scaffold(
      body: ResponsiveScreen(
        topMessageArea: Center(
          child: WarningBanner('Only the first 3~5 levels really work.'),
        ),
        squarishMainArea: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Select level',
                      style: TextStyle(
                          fontFamily: 'Permanent Marker', fontSize: 30),
                    ),
                  ),
                ),
              ),
              for (final level in gameLevels)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 30,
                    maxWidth: 120,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: InkResponse(
                      onTap:
                          playerProgress.highestLevelReached >= level.number - 1
                              ? () => GoRouter.of(context)
                                  .go('/play/session/${level.number}')
                              : null,
                      child: Stack(
                        children: [
                          SizedBox.expand(
                            child: Image.asset(
                              'assets/images/box.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Center(
                              child: Text(
                            '#${level.number}',
                            style: TextStyle(
                              color: playerProgress.highestLevelReached >=
                                      level.number - 1
                                  ? palette.redPen
                                  : palette.ink.withOpacity(0.5),
                              fontFamily: 'Permanent Marker',
                              fontSize: 30,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        rectangularMenuArea: RoughButton(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
