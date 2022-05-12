import 'dart:async';

import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:logging/logging.dart';
import 'package:tictactoe/src/games_services/score.dart' as internal;
import 'package:tictactoe/src/style/error_snackbar.dart';

class GamesServicesController {
  static final Logger _log = Logger('GamesServicesController');

  final Completer<bool> _signedInCompleter = Completer();

  Future<bool> get signedIn => _signedInCompleter.future;

  void initialize() async {
    try {
      await GamesServices.signIn();
      // The API is unclear so we're checking to be sure. The above call
      // returns a String, not a boolean, and there's no documentation
      // as to whether every non-error result means we're safely signed in.
      final signedIn = await GamesServices.isSignedIn;
      _signedInCompleter.complete(signedIn);
    } catch (e) {
      _log.severe('Cannot log into GamesServices: $e');
      _signedInCompleter.complete(false);
    }
  }

  void showAchievements() async {
    if (!await signedIn) {
      showErrorSnackbar(
        'sign in to view achivements',
        action: SnackBarAction(
          label: 'Sign in',
          onPressed: initialize,
        ),
      );
      _log.severe('Trying to show achievements when not logged in.');
      return;
    }

    try {
      await GamesServices.showAchievements();
    } catch (e) {
      _log.severe('Cannot show achievements: $e');
    }
  }

  void showLeaderboard() async {
    if (!await signedIn) {
      showErrorSnackbar(
        'sign in to view leaderboard',
        action: SnackBarAction(
          label: 'Sign in',
          onPressed: initialize,
        ),
      );
      _log.severe('Trying to show leaderboard when not logged in.');
      return;
    }

    try {
      await GamesServices.showLeaderboards(
        iOSLeaderboardID: "tictactoe.highest_score",
        androidLeaderboardID: "CgkIgZ29mawJEAIQAQ",
      );
    } catch (e) {
      _log.severe('Cannot show leaderboard: $e');
    }
  }

  void awardAchievement({required String iOS, required String android}) async {
    if (!await signedIn) {
      _log.warning('Trying to award achievement when not logged in.');
      return;
    }

    try {
      await GamesServices.unlock(
        achievement: Achievement(
          androidID: android,
          iOSID: iOS,
        ),
      );
    } catch (e) {
      _log.severe('Cannot award achievement: $e');
    }
  }

  void submitLeaderboardScore(internal.Score score) async {
    if (!await signedIn) {
      _log.warning('Trying to submit leaderboard when not logged in.');
      return;
    }

    _log.info('Submitting $score to leaderboard.');

    try {
      await GamesServices.submitScore(
        score: Score(
          iOSLeaderboardID: 'tictactoe.highest_score',
          androidLeaderboardID: 'CgkIgZ29mawJEAIQAQ',
          value: score.score,
        ),
      );
    } catch (e) {
      _log.severe('Cannot submit leaderboard score: $e');
    }
  }
}
