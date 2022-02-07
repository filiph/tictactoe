import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/game_internals/ai_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/play_session/game_board.dart';
import 'package:flutter_game_sample/src/rough/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PlaySessionScreen extends StatelessWidget {
  final BoardSetting setting;

  const PlaySessionScreen(this.setting, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BoardState.clean(setting),
        ),
        Provider(
          create: (context) => RandomOpponent(setting),
        ),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              Board(
                  setting: setting,
                  onPlayerWon: () {
                    GoRouter.of(context).go('/play/won');
                  }),
              const Spacer(),
              Builder(builder: (context) {
                return RoughButton(
                  onTap: () => context.read<BoardState>().clearBoard(),
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
    );
  }
}
