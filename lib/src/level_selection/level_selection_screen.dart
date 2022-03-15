import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/achievements/player_progress.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/style/delayed_appear.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              DelayedAppear(
                ms: ScreenDelays.first,
                child: SizedBox(
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
              ),
              for (var i = 0; i < gameLevels.length; i++)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 30,
                    maxWidth: 120,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DelayedAppear(
                      ms: ScreenDelays.second + i * 70,
                      child: InkResponse(
                        onTap: playerProgress.highestLevelReached >=
                                gameLevels[i].number - 1
                            ? () => GoRouter.of(context)
                                .go('/play/session/${gameLevels[i].number}')
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
                              '#${gameLevels[i].number}',
                              style: TextStyle(
                                color: playerProgress.highestLevelReached >=
                                        gameLevels[i].number - 1
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
                  ),
                )
            ],
          ),
        ),
        rectangularMenuArea: DelayedAppear(
          ms: ScreenDelays.fourth,
          child: RoughButton(
            onTap: () {
              GoRouter.of(context).pop();
            },
            child: const Text('Back'),
          ),
        ),
      ),
    );
  }
}
