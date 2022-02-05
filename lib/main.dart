import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/play_session/play_session_screen.dart';
import 'package:flutter_game_sample/src/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
          routes: [
            // TODO: go route for "play", which is the setup screen
            GoRoute(
              path: 'play/:m/:n/:k',
              builder: (context, state) => PlaySessionScreen(BoardSetting(
                int.parse(state.params['m']!),
                int.parse(state.params['n']!),
                int.parse(state.params['k']!),
              )),
            ),
          ]),
    ],
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.red,
          ),
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
        ),
      ),
    );
  }
}
