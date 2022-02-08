import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/level_selection/level_selection_screen.dart';
import 'package:flutter_game_sample/src/main_menu/main_menu_screen.dart';
import 'package:flutter_game_sample/src/play_session/play_session_screen.dart';
import 'package:flutter_game_sample/src/win_game/win_game_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  debugPrint('Starting app');
  runApp(const MyApp());
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
                    path: ':m/:n/:k',
                    builder: (context, state) => PlaySessionScreen(
                      BoardSetting(
                        int.parse(state.params['m']!),
                        int.parse(state.params['n']!),
                        int.parse(state.params['k']!),
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'won',
                    builder: (context, state) => WinGameScreen(),
                  )
                ]),
          ]),
    ],
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.red,
        ),
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }
}
