import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/rough/button.dart';
import 'package:go_router/go_router.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(34),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _gap,
                  const Text(
                    'Achievements',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Permanent Marker',
                      fontSize: 45,
                      height: 1,
                    ),
                  ),
                  _gap,
                  Text('NOT IMPLEMENTED.\n\n'
                      'Nothing to show here yet, '
                      'but this screen will hold a leaderboard '
                      'as well as a list of “achievements” such as '
                      '“Won in 5 moves,” '
                      '“Gomoku champion” or '
                      '“The only winning move is not to play.”'),
                  _gap,
                ],
              ),
            ),
            Center(
              child: RoughButton(
                onTap: () {
                  GoRouter.of(context).pop();
                },
                child: const Text('Back'),
              ),
            ),
            _gap,
          ],
        ),
      ),
    );
  }
}
