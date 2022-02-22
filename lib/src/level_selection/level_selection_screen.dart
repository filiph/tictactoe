import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/achievements/player_progress.dart';
import 'package:flutter_game_sample/src/level_selection/levels.dart';
import 'package:flutter_game_sample/src/style/responsive_screen.dart';
import 'package:flutter_game_sample/src/style/rough/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      body: ResponsiveScreen(
        squarishMainArea: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Select level',
                    style:
                        TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
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
                    aspectRatio: 3 / 2,
                    child: RoughButton(
                      onTap:
                          playerProgress.highestLevelReached >= level.number - 1
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
