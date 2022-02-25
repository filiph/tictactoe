import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tictactoe/src/achievements/score.dart';

class MemoryOnlyPlayerProgressPersistentStore
    implements PlayerProgressPersistentStore {
  int level = 0;

  List<Score> highestScores = [];

  @override
  Future<int> getHighestLevelReached() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return level;
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    await Future.delayed(const Duration(milliseconds: 500));
    this.level = level;
  }

  @override
  Future<List<Score>> getHighestScores() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return highestScores;
  }

  @override
  Future<void> saveHighestScores(List<Score> scores) async {
    await Future.delayed(const Duration(milliseconds: 500));
    highestScores = scores;
  }
}

class PlayerProgress extends ChangeNotifier {
  final PlayerProgressPersistentStore _store;

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
    }
  }

  reset() {
    _highestLevelReached = 0;
    _highestScores = [];
    notifyListeners();
    unawaited(_store.saveHighestLevelReached(_highestLevelReached));
  }

  void addScore(Score score) {
    _highestScores.add(score);
    _highestScores.sort((a, b) => -a.score.compareTo(b.score));
    while (_highestScores.length > maxHighestScoresPerPlayer) {
      _highestScores.removeLast();
    }
    notifyListeners();
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

abstract class PlayerProgressPersistentStore {
  Future<int> getHighestLevelReached();

  Future<void> saveHighestLevelReached(int level);

  Future<List<Score>> getHighestScores();

  Future<void> saveHighestScores(List<Score> scores);
}
