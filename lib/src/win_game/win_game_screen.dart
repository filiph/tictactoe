import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/achievements/score.dart';
import 'package:tictactoe/src/ads/banner_ad.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/style/colors.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;

  const WinGameScreen({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final adsRemoved = context.watch<Settings>().adsRemoved;

    const gap = SizedBox(height: 10);

    return Scaffold(
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!adsRemoved &&
                // Since this is a compile-time constant, the web version
                // won't even import the code for ad serving. Tree shaking ftw.
                !kIsWeb &&
                (Platform.isIOS || Platform.isAndroid)) ...[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: palette.light,
                    child: Center(child: MyBannerAd()),
                  ),
                ),
              ),
            ],
            gap,
            Center(
              child: Text(
                'You won!',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            Center(
              child: Text(
                'Score: ${score.score}\n'
                'Time: ${score.formattedTime}',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 20),
              ),
            ),
            gap,
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
          ],
        ),
        rectangularMenuArea: RoughButton(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
