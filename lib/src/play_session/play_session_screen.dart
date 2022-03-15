import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart' as games_services;
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/achievements/player_progress.dart';
import 'package:tictactoe/src/achievements/score.dart';
import 'package:tictactoe/src/ads/preloaded_banner_ad.dart';
import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/audio/audio_system.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/in_app_purchase/in_app_purchase.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/play_session/game_board.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/style/delayed_appear.dart';
import 'package:tictactoe/src/style/palette.dart';

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

  late final AiOpponent opponent;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
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
          backgroundColor: palette.backgroundPlaySession,
          body: Stack(
            children: [
              Builder(builder: (context) {
                final textStyle = DefaultTextStyle.of(context).style.copyWith(
                      fontFamily: 'Permanent Marker',
                      fontSize: 24,
                      color: palette.redPen,
                    );

                return _ResponsivePlaySessionScreen(
                  playerName: TextSpan(
                    text: 'Player',
                    style: textStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _log.warning('NOT IMPLEMENTED YET'),
                  ),
                  opponentName: TextSpan(
                    text: opponent.name,
                    style: textStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _log.warning('NOT IMPLEMENTED YET'),
                  ),
                  mainBoardArea: Center(
                    child: DelayedAppear(
                      ms: ScreenDelays.fourth,
                      delayStateCreation: true,
                      child: Board(
                        key: Key('main board'),
                        setting: widget.level.setting,
                      ),
                    ),
                  ),
                  restartButtonArea: Builder(
                    builder: (context) {
                      return DelayedAppear(
                        ms: ScreenDelays.fourth,
                        child: InkResponse(
                          onTap: () {
                            final settings = context.read<Settings>();
                            if (!settings.muted && settings.soundsOn) {
                              final audioSystem = context.read<AudioSystem>();
                              audioSystem.playSfx(SfxType.buttonTap);
                            }

                            context.read<BoardState>().clearBoard();
                            _startOfPlay = DateTime.now();
                          },
                          child: Column(
                            children: [
                              Image.asset('assets/images/restart.png'),
                              Text(
                                'Restart',
                                style: TextStyle(
                                  fontFamily: 'Permanent Marker',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  backButtonArea: DelayedAppear(
                    ms: ScreenDelays.first,
                    child: InkResponse(
                      onTap: () {
                        final settings = context.read<Settings>();
                        if (!settings.muted && settings.soundsOn) {
                          final audioSystem = context.read<AudioSystem>();
                          audioSystem.playSfx(SfxType.buttonTap);
                        }

                        GoRouter.of(context).pop();
                      },
                      child: Tooltip(
                        message: 'Back',
                        child: Image.asset('assets/images/back.png'),
                      ),
                    ),
                  ),
                  settingsButtonArea: DelayedAppear(
                    ms: ScreenDelays.third,
                    child: InkResponse(
                      onTap: () {
                        final settings = context.read<Settings>();
                        if (!settings.muted && settings.soundsOn) {
                          final audioSystem = context.read<AudioSystem>();
                          audioSystem.playSfx(SfxType.buttonTap);
                        }

                        GoRouter.of(context).push('/settings');
                      },
                      child: Tooltip(
                        message: 'Settings',
                        child: Image.asset('assets/images/settings.png'),
                      ),
                    ),
                  ),
                );
              }),
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

    opponent = widget.level.aiOpponentBuilder(widget.level.setting);
    _log.info('$opponent enters the fray');

    _startOfPlay = DateTime.now();

    final adsRemoved =
        context.read<InAppPurchaseNotifier?>()?.adRemoval.active ?? false;
    if (!adsRemoved &&
        // Since this is a compile-time constant, the web version
        // won't even import the code for ad serving. Tree shaking ftw.
        !kIsWeb &&
        platformSupportsAds) {
      _preloadedAd = PreloadedBannerAd(size: AdSize.mediumRectangle);
      Future<void>.delayed(const Duration(seconds: 1))
          .then((_) => _preloadedAd!.load());
    }
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
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final settings = context.read<Settings>();
    if (!settings.muted && settings.soundsOn) {
      final audioSystem = context.read<AudioSystem>();
      audioSystem.playSfx(SfxType.congrats);
    }

    /// Give the player some time to see the celebration animation.
    await Future.delayed(_celebrationDuration);
    if (!mounted) return;

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
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {
      'score': score,
      'preloaded_ad': _preloadedAd,
    });
  }

  PreloadedBannerAd? _preloadedAd;
}

class _ResponsivePlaySessionScreen extends StatelessWidget {
  /// This is the "hero" of the screen. It's more or less square, and will
  /// be placed in the visual "center" of the screen.
  final Widget mainBoardArea;

  final Widget backButtonArea;

  final Widget settingsButtonArea;

  final Widget restartButtonArea;

  final TextSpan playerName;

  final TextSpan opponentName;

  /// How much bigger should the [mainBoardArea] be compared to the other
  /// elements.
  final double mainAreaProminence;

  const _ResponsivePlaySessionScreen({
    required this.mainBoardArea,
    required this.backButtonArea,
    required this.settingsButtonArea,
    required this.restartButtonArea,
    required this.playerName,
    required this.opponentName,
    this.mainAreaProminence = 0.8,
    Key? key,
  }) : super(key: key);

  Widget _buildVersusText(BuildContext context, TextAlign textAlign) {
    String versusText;
    switch (textAlign) {
      case TextAlign.start:
      case TextAlign.left:
      case TextAlign.right:
      case TextAlign.end:
        versusText = '\nversus\n';
        break;
      case TextAlign.center:
      case TextAlign.justify:
        versusText = ' versus ';
        break;
    }

    return DelayedAppear(
      ms: ScreenDelays.second,
      child: RichText(
          textAlign: textAlign,
          text: TextSpan(
            children: [
              playerName,
              TextSpan(
                text: versusText,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontFamily: 'Permanent Marker', fontSize: 18),
              ),
              opponentName,
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // This widget wants to fill the whole screen.
        final size = constraints.biggest;
        final padding = EdgeInsets.all(size.shortestSide / 30);

        if (size.height >= size.width) {
          // "Portrait" / "mobile" mode.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: padding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                        child: backButtonArea,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 5,
                          ),
                          child: _buildVersusText(context, TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        child: settingsButtonArea,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: (mainAreaProminence * 100).round(),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  minimum: padding,
                  child: mainBoardArea,
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: padding,
                  child: restartButtonArea,
                ),
              ),
            ],
          );
        } else {
          // "Landscape" / "tablet" mode.
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: SafeArea(
                  right: false,
                  child: Padding(
                    padding: padding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        backButtonArea,
                        Expanded(
                          child: _buildVersusText(context, TextAlign.start),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: SafeArea(
                  left: false,
                  right: false,
                  minimum: padding,
                  child: mainBoardArea,
                ),
              ),
              Expanded(
                flex: 3,
                child: SafeArea(
                  left: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: padding,
                        child: settingsButtonArea,
                      ),
                      Spacer(),
                      Padding(
                        padding: padding,
                        child: restartButtonArea,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
