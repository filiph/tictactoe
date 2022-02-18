import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/achievements/player_progress.dart';
import 'package:flutter_game_sample/src/style/rough/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
                  _SettingsLine(
                    'Reset game',
                    Icons.restart_alt,
                    onSelected: () {
                      context.read<PlayerProgress>().reset();

                      final messenger = ScaffoldMessenger.of(context);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        SnackBar(
                            content: Text('Player progress has been reset.')),
                      );
                    },
                  ),
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

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected, Key? key})
      : super(key: key);

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
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            if (onSelected != null) {
              onSelected!();
              return;
            }

            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            messenger.showSnackBar(
              SnackBar(content: Text('Not implemented yet.')),
            );
          },
        ),
      ],
    );
  }
}
