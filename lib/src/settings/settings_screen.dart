import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/achievements/player_progress.dart';
import 'package:tictactoe/src/in_app_purchase/in_app_purchase.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<Settings>();
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundSettings,
      body: ResponsiveScreen(
        squarishMainArea: ListView(
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
            _SettingsLine(
              'Sound FX',
              Icon(settings.soundsOn ? Icons.graphic_eq : Icons.volume_off),
              onSelected: () => settings.toggleSoundsOn(),
            ),
            _SettingsLine(
              'Music',
              Icon(settings.musicOn ? Icons.music_note : Icons.music_off),
              onSelected: () => settings.toggleMusicOn(),
            ),
            if (platformSupportsInAppPurchases)
              Consumer<InAppPurchaseNotifier>(
                  builder: (context, inAppPurchase, child) {
                Widget icon;
                VoidCallback? callback;
                if (inAppPurchase.adRemoval.active) {
                  icon = Icon(Icons.check);
                } else if (inAppPurchase.adRemoval.pending) {
                  icon = CircularProgressIndicator();
                } else {
                  icon = Icon(Icons.ad_units);
                  callback = () {
                    inAppPurchase.buy();
                  };
                }
                return _SettingsLine(
                  'Remove ads',
                  icon,
                  onSelected: callback,
                );
              }),
            _SettingsLine(
              'Reset game',
              Icon(Icons.restart_alt),
              onSelected: () {
                context.read<PlayerProgress>().reset();

                final messenger = ScaffoldMessenger.of(context);
                messenger.clearSnackBars();
                messenger.showSnackBar(
                  SnackBar(content: Text('Player progress has been reset.')),
                );
              },
            ),
            _gap,
          ],
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

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

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
          icon: icon,
          onPressed: onSelected,
        ),
      ],
    );
  }
}
