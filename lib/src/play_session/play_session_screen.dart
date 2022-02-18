import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/achievements/player_progress.dart';
import 'package:flutter_game_sample/src/achievements/score.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/level_selection/levels.dart';
import 'package:flutter_game_sample/src/play_session/game_board.dart';
import 'package:flutter_game_sample/src/style/rough/button.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;

  const PlaySessionScreen(this.level, {Key? key}) : super(key: key);

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final opponent =
                widget.level.aiOpponentBuilder(widget.level.setting);
            _log.info('$opponent enters');

            final state = BoardState.clean(
              widget.level.setting,
              opponent,
            );

            state.playerWon.addListener(_playerWon);
            state.aiOpponentWon.addListener(_aiOpponentWon);

            return state;
          },
        ),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: Scaffold(
          body: Stack(
            children: [
              SizedBox.expand(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/images/background.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      widget.level.message,
                      style: TextStyle(
                          fontFamily: 'Permanent Marker', fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  Board(setting: widget.level.setting),
                  const Spacer(),
                  Builder(builder: (context) {
                    return RoughButton(
                      onTap: () {
                        context.read<BoardState>().clearBoard();
                        _startOfPlay = DateTime.now();
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
  }

  void _aiOpponentWon() {
    // Nothing to do. The board is locked.
  }

  void _playerWon() async {
    final score = Score(
      widget.level.number,
      widget.level.setting,
      widget.level.aiDifficulty,
      DateTime.now().difference(_startOfPlay),
    );

    setState(() {
      _duringCelebration = true;
    });

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(widget.level.number);
    playerProgress.addScore(score);

    await Future.delayed(const Duration(milliseconds: 1000));

    GoRouter.of(context).go('/play/won', extra: score);
  }
}
