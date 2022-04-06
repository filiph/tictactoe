import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:tictactoe/src/games_services/score.dart';
import 'package:tictactoe/src/player_progress/persistence/player_progress_persistence.dart';

class PlayerProgress extends ChangeNotifier {
  final PlayerProgressPersistence _store;

  int _highestLevelReached = 0;

  List<Score> _highestScores = [];

  PlayerProgress(this._store);

  int get highestLevelReached => _highestLevelReached;

  UnmodifiableListView<Score> get highestScores =>
      UnmodifiableListView(_highestScores);

  void getLatestFromStore() async {
    final level = await _store.getHighestLevelReached();
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();
    } else if (level < _highestLevelReached) {
      _store.saveHighestLevelReached(_highestLevelReached);
    }
  }

  void reset() {
    _highestLevelReached = 0;
    _highestScores = [];
    notifyListeners();
    _store.saveHighestLevelReached(_highestLevelReached);
    _store.saveHighestScores(_highestScores);
  }

  void addScore(Score score) {
    _highestScores.add(score);
    _highestScores.sort((a, b) => -a.score.compareTo(b.score));
    while (_highestScores.length > maxHighestScoresPerPlayer) {
      _highestScores.removeLast();
    }
    notifyListeners();
    _store.saveHighestScores(_highestScores);
  }

  static const maxHighestScoresPerPlayer = 10;

  void setLevelReached(int level) {
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();

      unawaited(_store.saveHighestLevelReached(level));
    }
  }
}
