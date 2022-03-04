import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart' as games_services;
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/achievements/player_progress.dart';
import 'package:tictactoe/src/achievements/score.dart';
import 'package:tictactoe/src/audio/audio_system.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/play_session/game_board.dart';
import 'package:tictactoe/src/style/responsive_screen.dart';
import 'package:tictactoe/src/style/rough/button.dart';

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;

  const PlaySessionScreen(this.level, {Key? key}) : super(key: key);

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

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
              ResponsiveScreen(
                topMessageArea: Text(
                  widget.level.message,
                  key: Key('level message'),
                  style:
                      TextStyle(fontFamily: 'Permanent Marker', fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                squarishMainArea: Center(
                  child: Board(
                    key: Key('main board'),
                    setting: widget.level.setting,
                  ),
                ),
                rectangularMenuArea: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        return RoughButton(
                          onTap: () {
                            context.read<BoardState>().clearBoard();
                            _startOfPlay = DateTime.now();
                          },
                          child: const Text('Restart'),
                        );
                      }),
                    ),
                    Expanded(
                      child: RoughButton(
                        onTap: () {
                          GoRouter.of(context).pop();
                        },
                        child: const Text('Back'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/images/confetti.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(widget.level.number);
    playerProgress.addScore(score);

    /// Let the player see the board just after winning for a bit.
    await Future.delayed(_preCelebrationDuration);

    setState(() {
      _duringCelebration = true;
    });

    final audioSystem = context.read<AudioSystem>();
    audioSystem.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
    await Future.delayed(_celebrationDuration);

    if (platformSupportsGameServices) {
      if (await games_services.GamesServices.isSignedIn) {
        _log.info('Submitting $score to leaderboard.');
        games_services.GamesServices.submitScore(
            score: games_services.Score(
          iOSLeaderboardID: "tictactoe.highest_score",
          androidLeaderboardID: "CgkIgZ29mawJEAIQAQ",
          value: score.score,
        ));
      }
    }

    GoRouter.of(context).go('/play/won', extra: score);
  }
}
