import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart' hide Score;
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/achievements/achievements_screen.dart';
import 'package:tictactoe/src/achievements/player_progress.dart';
import 'package:tictactoe/src/achievements/score.dart';
import 'package:tictactoe/src/audio/audio_system.dart';
import 'package:tictactoe/src/in_app_purchase/in_app_purchase.dart';
import 'package:tictactoe/src/level_selection/level_selection_screen.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/main_menu/main_menu_screen.dart';
import 'package:tictactoe/src/play_session/play_session_screen.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/settings/settings_screen.dart';
import 'package:tictactoe/src/snack_bar/snack_bar.dart';
import 'package:tictactoe/src/style/colors.dart';
import 'package:tictactoe/src/win_game/win_game_screen.dart';

void main() {
  if (kReleaseMode) {
    // Don't log anything below warnings in production.
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: '
        '${record.loggerName}: '
        '${record.message}');
  });

  final flavorIsDefined = checkFlavorDefined();

  if (!flavorIsDefined) {
    runApp(MaterialApp(
      home: ErrorWidget(StateError('Game was built with undefined flavor')),
    ));
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();

  // Blocked on a profile/release mode bug:
  //     https://github.com/flutter/flutter/issues/98973
  //
  // _log.info('Going full screen');
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [SystemUiOverlay.top],
  // );

  if (platformSupportsAds) {
    /// Prepare the google_mobile_ads plugin so that the first ad loads
    /// immediately. This can be done later or with a delay if startup experience
    /// suffers.
    MobileAds.instance.initialize();
  }

  if (platformSupportsGameServices) {
    GamesServices.signIn();
  }

  InAppPurchaseNotifier inAppPurchaseNotifier;
  if (platformSupportsInAppPurchases) {
    // Subscribing to [InAppPurchase.instance.purchaseStream] as soon
    // as possible in order not to miss any updates.
    inAppPurchaseNotifier = InAppPurchaseNotifier(InAppPurchase.instance)
      ..subscribe(InAppPurchase.instance.purchaseStream)
      ..restorePurchases();
  } else {
    inAppPurchaseNotifier = InAppPurchaseNotifier(null);
  }

  _log.info('Starting game in $flavor');
  runApp(
    MyApp(
      playerProgressPersistentStore: MemoryOnlyPlayerProgressPersistentStore(),
      inAppPurchaseNotifier: inAppPurchaseNotifier,
    ),
  );
}

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const MainMenuScreen(),
          routes: [
            GoRoute(
                path: 'play',
                builder: (context, state) => const LevelSelectionScreen(),
                routes: [
                  GoRoute(
                    path: 'session/:level',
                    builder: (context, state) {
                      final levelNumber = int.parse(state.params['level']!);
                      final level = gameLevels
                          .singleWhere((e) => e.number == levelNumber);
                      return PlaySessionScreen(level);
                    },
                  ),
                  GoRoute(
                    path: 'won',
                    builder: (context, state) =>
                        WinGameScreen(score: state.extra! as Score),
                  )
                ]),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: 'achievements',
              builder: (context, state) => const AchievementsScreen(),
            ),
          ]),
    ],
  );

  final PlayerProgressPersistentStore playerProgressPersistentStore;

  final InAppPurchaseNotifier inAppPurchaseNotifier;

  const MyApp({
    required this.playerProgressPersistentStore,
    required this.inAppPurchaseNotifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioSystemWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              var progress = PlayerProgress(playerProgressPersistentStore);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider.value(value: inAppPurchaseNotifier),
          ChangeNotifierProxyProvider<AudioSystem, Settings>(
            lazy: false,
            create: (context) => Settings(),
            update: (context, audioSystem, settings) {
              if (settings == null) throw ArgumentError.notNull();
              settings.attachAudioSystem(audioSystem);
              return settings;
            },
          ),
          Provider(
            create: (context) => Palette(),
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.darkPen,
                background: palette.background,
              ),
              textTheme: TextTheme(
                bodyText2: TextStyle(
                  color: palette.ink,
                ),
              ),
            ),
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            scaffoldMessengerKey: scaffoldMessengerKey,
          );
        }),
      ),
    );
  }
}

Logger _log = Logger('main.dart');
