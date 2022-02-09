import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/achievements/player_progress.dart';
import 'package:flutter_game_sample/src/achievements/score.dart';
import 'package:flutter_game_sample/src/ads/interstitial_ad.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/level_selection/levels.dart';
import 'package:flutter_game_sample/src/play_session/game_board.dart';
import 'package:flutter_game_sample/src/settings/settings.dart';
import 'package:flutter_game_sample/src/style/rough/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PlaySessionScreen extends StatefulWidget {
  final Level level;

  const PlaySessionScreen(this.level, {Key? key}) : super(key: key);

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
      _banner;

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  @override
  void dispose() {
    _banner?.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final settings = context.read<Settings>();

    if (widget.level.number == 1 || settings.adsRemoved) {
      // Don't show ad if this is the first level or the player
      // paid for removed ads.
      _showAd = false;
      _startOfPlay = DateTime.now();
    } else {
      // Show ad.
      _showAd = true;
    }
  }

  bool _showAd = true;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final state = BoardState.clean(
              widget.level.setting,
              widget.level.aiOpponentBuilder(widget.level.setting),
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
              if (_showAd)
                InterstitialAd(
                  onClose: () {
                    setState(() {
                      _showAd = false;
                      _startOfPlay = DateTime.now();
                    });
                  },
                ),
            ],
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
    final score = Score(
      widget.level.setting,
      1 /* TODO: input AI difficuly */,
      DateTime.now().difference(_startOfPlay),
    );

    setState(() {
      _duringCelebration = true;
    });

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(widget.level.number);
    playerProgress.addScore(score);

    await Future.delayed(const Duration(milliseconds: 500));

    GoRouter.of(context).go('/play/won', extra: score);
  }
}
