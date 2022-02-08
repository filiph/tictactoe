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
                  for (var i = 0; i < 9; i++)
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
                              : i == 1
                                  ? () {
                                      GoRouter.of(context).go('/play/5/5/4/');
                                    }
                                  : null,
                          child: Center(child: Text('#${i + 1}')),
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
