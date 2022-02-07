import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/rough/button.dart';
import 'package:go_router/go_router.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

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
                'Select level',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
              ),
            ),
            const Spacer(),
            Wrap(
              children: [
                for (var i = 0; i < 12; i++)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 30,
                      maxWidth: 120,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: RoughButton(
                        onTap: i == 0
                            ? () {
                                GoRouter.of(context).go('/play/3/3/3/');
                              }
                            : null,
                        child: Center(child: Text('#${i + 1}')),
                      ),
                    ),
                  )
              ],
            ),
            Spacer(),
            RoughButton(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: const Text('Back'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
