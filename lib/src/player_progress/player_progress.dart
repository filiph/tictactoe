import 'dart:async';

import 'package:flutter/cupertino.dart';

class MemoryOnlyPlayerProgressPersistentStore
    implements PlayerProgressPersistentStore {
  int level = 0;

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
}

class PlayerProgress extends ChangeNotifier {
  final PlayerProgressPersistentStore _store;

  int _highestLevelReached = 0;

  PlayerProgress(this._store);

  int get highestLevelReached => _highestLevelReached;

  void getLatestFromStore() async {
    final level = await _store.getHighestLevelReached();
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();
    }
  }

  reset() {
    _highestLevelReached = 0;
    unawaited(_store.saveHighestLevelReached(_highestLevelReached));
  }

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
}
