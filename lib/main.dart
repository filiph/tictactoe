import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:games_services/games_services.dart' hide Score;
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/achievements/achievements_screen.dart';
import 'package:tictactoe/src/achievements/persistence/local_storage_player_progress_persistence.dart';
import 'package:tictactoe/src/achievements/persistence/player_progress_persistence.dart';
import 'package:tictactoe/src/achievements/player_progress.dart';
import 'package:tictactoe/src/achievements/score.dart';
import 'package:tictactoe/src/app_lifecycle/app_lifecycle.dart';
import 'package:tictactoe/src/audio/audio_system.dart';
import 'package:tictactoe/src/in_app_purchase/in_app_purchase.dart';
import 'package:tictactoe/src/level_selection/level_selection_screen.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/main_menu/main_menu_screen.dart';
import 'package:tictactoe/src/play_session/play_session_screen.dart';
import 'package:tictactoe/src/settings/persistence/local_storage_settings_persistence.dart';
import 'package:tictactoe/src/settings/persistence/settings_persistence.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/settings/settings_screen.dart';
import 'package:tictactoe/src/snack_bar/snack_bar.dart';
import 'package:tictactoe/src/style/colors.dart';
import 'package:tictactoe/src/style/ink_transition.dart';
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

  _log.info('Going full screen');
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  if (platformSupportsAds) {
    /// Prepare the google_mobile_ads plugin so that the first ad loads
    /// immediately. This can be done later or with a delay if startup experience
    /// suffers.
    MobileAds.instance.initialize();
  }

  if (platformSupportsGameServices) {
    GamesServices.signIn();
  }

  InAppPurchaseNotifier? inAppPurchaseNotifier;
  if (platformSupportsInAppPurchases) {
    inAppPurchaseNotifier = InAppPurchaseNotifier(InAppPurchase.instance)
      // Subscribing to [InAppPurchase.instance.purchaseStream] as soon
      // as possible in order not to miss any updates.
      ..subscribe(InAppPurchase.instance.purchaseStream)
      // Ask the store what the player has bought already.
      ..restorePurchases();
  }

  _log.info('Starting game in $flavor');
  runApp(
    MyApp(
      settingsPersistence: LocalStorageSettingsPersistence(),
      playerProgressPersistentStore: LocalStoragePlayerProgressPersistence(),
      inAppPurchaseNotifier: inAppPurchaseNotifier,
    ),
  );
}

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const InkTransitionPage(child: MainMenuScreen()),
          routes: [
            GoRoute(
                path: 'play',
                pageBuilder: (context, state) =>
                    const InkTransitionPage(child: LevelSelectionScreen()),
                routes: [
                  GoRoute(
                    path: 'session/:level',
                    pageBuilder: (context, state) {
                      final levelNumber = int.parse(state.params['level']!);
                      final level = gameLevels
                          .singleWhere((e) => e.number == levelNumber);
                      return InkTransitionPage(child: PlaySessionScreen(level));
                    },
                  ),
                  GoRoute(
                    path: 'won',
                    pageBuilder: (context, state) => InkTransitionPage(
                        child: WinGameScreen(score: state.extra! as Score)),
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

  final SettingsPersistence settingsPersistence;

  final InAppPurchaseNotifier? inAppPurchaseNotifier;

  const MyApp({
    required this.playerProgressPersistentStore,
    required this.settingsPersistence,
    required this.inAppPurchaseNotifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              var progress = PlayerProgress(playerProgressPersistentStore);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          ChangeNotifierProvider<InAppPurchaseNotifier?>.value(
              value: inAppPurchaseNotifier),
          ChangeNotifierProvider<AudioSystem>(
            create: (context) => AudioSystem()..initialize(),
          ),
          ChangeNotifierProxyProvider2<AudioSystem,
              ValueNotifier<AppLifecycleState>, Settings>(
            lazy: false,
            create: (context) => Settings(
              persistence: settingsPersistence,
            )..loadStateFromPersistence(),
            update: (context, audioSystem, lifecycleNotifier, settings) {
              if (settings == null) throw ArgumentError.notNull();
              settings.attachAudioSystem(audioSystem);
              settings.attachLifecycleNotifier(lifecycleNotifier);
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
