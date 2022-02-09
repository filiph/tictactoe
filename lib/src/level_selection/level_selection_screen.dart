import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/achievements/player_progress.dart';
import 'package:flutter_game_sample/src/level_selection/levels.dart';
import 'package:flutter_game_sample/src/style/rough/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                'Select level',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: GridView.extent(
                maxCrossAxisExtent: 170,
                children: [
                  for (final level in gameLevels)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 30,
                        maxWidth: 120,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: RoughButton(
                          onTap: playerProgress.highestLevelReached >=
                                  level.number - 1
                              ? () => GoRouter.of(context)
                                  .go('/play/session/', extra: level)
                              : null,
                          child: Center(child: Text('#${level.number}')),
                        ),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RoughButton(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: const Text('Back'),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
