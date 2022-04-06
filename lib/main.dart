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
import 'package:tictactoe/src/ads/ads_controller.dart';
import 'package:tictactoe/src/app_lifecycle/app_lifecycle.dart';
import 'package:tictactoe/src/audio/audio_controller.dart';
import 'package:tictactoe/src/games_services/score.dart';
import 'package:tictactoe/src/in_app_purchase/in_app_purchase.dart';
import 'package:tictactoe/src/level_selection/level_selection_screen.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/main_menu/main_menu_screen.dart';
import 'package:tictactoe/src/play_session/play_session_screen.dart';
import 'package:tictactoe/src/player_progress/persistence/local_storage_player_progress_persistence.dart';
import 'package:tictactoe/src/player_progress/persistence/player_progress_persistence.dart';
import 'package:tictactoe/src/player_progress/player_progress.dart';
import 'package:tictactoe/src/settings/persistence/local_storage_settings_persistence.dart';
import 'package:tictactoe/src/settings/persistence/settings_persistence.dart';
import 'package:tictactoe/src/settings/settings.dart';
import 'package:tictactoe/src/settings/settings_screen.dart';
import 'package:tictactoe/src/snack_bar/snack_bar.dart';
import 'package:tictactoe/src/style/ink_transition.dart';
import 'package:tictactoe/src/style/palette.dart';
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

  AdsController? adsController;
  if (!kIsWeb && platformSupportsAds) {
    /// Prepare the google_mobile_ads plugin so that the first ad loads
    /// faster. This can be done later or with a delay if startup
    /// experience suffers.
    adsController = AdsController(MobileAds.instance);
    adsController.initialize();
  }

  if (platformSupportsGameServices) {
    GamesServices.signIn();
  }

  InAppPurchaseController? inAppPurchaseController;
  if (platformSupportsInAppPurchases) {
    inAppPurchaseController = InAppPurchaseController(InAppPurchase.instance)
      // Subscribing to [InAppPurchase.instance.purchaseStream] as soon
      // as possible in order not to miss any updates.
      ..subscribe();
    // Ask the store what the player has bought already.
    inAppPurchaseController.restorePurchases();
  }

  _log.info('Starting game in $flavor');
  runApp(
    MyApp(
      settingsPersistence: LocalStorageSettingsPersistence(),
      playerProgressPersistence: LocalStoragePlayerProgressPersistence(),
      inAppPurchaseController: inAppPurchaseController,
      adsController: adsController,
    ),
  );
}

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => MainMenuScreen(key: Key('main menu')),
          routes: [
            GoRoute(
                path: 'play',
                pageBuilder: (context, state) => buildTransition(
                      child: LevelSelectionScreen(key: Key('level selection')),
                      color: context.watch<Palette>().backgroundLevelSelection,
                    ),
                routes: [
                  GoRoute(
                    path: 'session/:level',
                    pageBuilder: (context, state) {
                      final levelNumber = int.parse(state.params['level']!);
                      final level = gameLevels
                          .singleWhere((e) => e.number == levelNumber);
                      return buildTransition(
                        child: PlaySessionScreen(
                          level,
                          key: Key('play session'),
                        ),
                        color: context.watch<Palette>().backgroundPlaySession,
                        flipHorizontally: true,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'won',
                    pageBuilder: (context, state) {
                      final map = state.extra! as Map<String, dynamic>;
                      final score = map['score'] as Score;

                      return buildTransition(
                        child: WinGameScreen(
                          score: score,
                          key: Key('win game'),
                        ),
                        color: context.watch<Palette>().backgroundPlaySession,
                        flipHorizontally: true,
                      );
                    },
                  )
                ]),
            GoRoute(
              path: 'settings',
              builder: (context, state) =>
                  const SettingsScreen(key: Key('settings')),
            ),
          ]),
    ],
  );

  final PlayerProgressPersistence playerProgressPersistence;

  final SettingsPersistence settingsPersistence;

  final InAppPurchaseController? inAppPurchaseController;

  final AdsController? adsController;

  const MyApp({
    required this.playerProgressPersistence,
    required this.settingsPersistence,
    required this.inAppPurchaseController,
    required this.adsController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              var progress = PlayerProgress(playerProgressPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          Provider<AdsController?>.value(value: adsController),
          ChangeNotifierProvider<InAppPurchaseController?>.value(
              value: inAppPurchaseController),
          ChangeNotifierProvider<AudioController>(
            create: (context) => AudioController()..initialize(),
          ),
          ChangeNotifierProxyProvider2<AudioController,
              ValueNotifier<AppLifecycleState>, SettingsController>(
            lazy: false,
            create: (context) => SettingsController(
              persistence: settingsPersistence,
            )..loadStateFromPersistence(),
            update: (context, audioController, lifecycleNotifier, settings) {
              if (settings == null) throw ArgumentError.notNull();
              settings.attachAudioController(audioController);
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
                background: palette.backgroundMain,
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
