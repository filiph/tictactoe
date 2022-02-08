import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/rough/button.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

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
                    'Settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Permanent Marker',
                      fontSize: 55,
                      height: 1,
                    ),
                  ),
                  _gap,
                  _SettingsLine('Sound FX', Icons.volume_off),
                  _SettingsLine('Music', Icons.music_off),
                  _SettingsLine('Remove ads', Icons.monetization_on),
                  _SettingsLine('Language', Icons.language),
                  _SettingsLine('Reset game', Icons.restart_alt),
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

class _SettingsLine extends StatelessWidget {
  final String title;

  final IconData icon;

  const _SettingsLine(this.title, this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 30,
            )),
        Spacer(),
        RoughButton(
          onTap: () {
            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            messenger.showSnackBar(
              SnackBar(content: Text('Not implemented yet.')),
            );
          },
          child: Icon(icon),
        ),
      ],
    );
  }
}
