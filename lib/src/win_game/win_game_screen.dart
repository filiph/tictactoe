import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/rough/button.dart';
import 'package:go_router/go_router.dart';

class WinGameScreen extends StatelessWidget {
  const WinGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const Spacer(),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.grey,
                child: Center(child: Text('Ads here')),
              ),
            ),
            Spacer(),
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
