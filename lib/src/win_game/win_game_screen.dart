import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/achievements/score.dart';
import 'package:flutter_game_sample/src/settings/settings.dart';
import 'package:flutter_game_sample/src/style/colors.dart';
import 'package:flutter_game_sample/src/style/rough/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;

  const WinGameScreen({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final adsRemoved = context.watch<Settings>().adsRemoved;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Center(
              child: Text(
                'You won!',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Score: ${score.score}\n'
                'Time: ${score.formattedTime}',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('NOT IMPLEMENTED YET, but this could use '
                        'Firebase / Google Cloud to save the finished game '
                        'board as a picture, so that the share is interesting'),
                  ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 10),
                    Text('Share'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (!adsRemoved) ...[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: palette.light,
                  child: Center(child: Text('Ads here')),
                ),
              ),
              Spacer(),
            ],
            RoughButton(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: const Text('Continue'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
