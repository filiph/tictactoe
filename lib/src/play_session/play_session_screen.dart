import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/game_internals/ai_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/play_session/game_board.dart';
import 'package:flutter_game_sample/src/rough/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PlaySessionScreen extends StatefulWidget {
  final BoardSetting setting;

  const PlaySessionScreen(this.setting, {Key? key}) : super(key: key);

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
      _banner;

  bool _duringCelebration = false;

  @override
  void dispose() {
    _banner?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final state = BoardState.clean(
                widget.setting, RandomOpponent(widget.setting));

            state.playerWon.addListener(_playerWon);
            state.aiOpponentWon.addListener(_aiOpponentWon);

            return state;
          },
        ),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                Board(setting: widget.setting),
                const Spacer(),
                Builder(builder: (context) {
                  return RoughButton(
                    onTap: () {
                      context.read<BoardState>().clearBoard();
                      _banner?.close();
                      _banner = null;
                    },
                    child: const Text('Restart'),
                  );
                }),
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
        ),
      ),
    );
  }

  void _aiOpponentWon() {
    _banner?.close();

    var banner = MaterialBanner(
        content: Text('Oh no! You lost. Might want to restart.'),
        actions: [
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).removeCurrentMaterialBanner(),
            child: Text('OK'),
          ),
        ]);

    _banner = ScaffoldMessenger.of(context).showMaterialBanner(banner);
  }

  void _playerWon() async {
    setState(() {
      _duringCelebration = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    GoRouter.of(context).go('/play/won');
  }
}
