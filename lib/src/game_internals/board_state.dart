import 'package:flutter/cupertino.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';

class BoardState extends ChangeNotifier {
  final BoardSetting setting;

  BoardState._(this.setting, this._xTaken, this._oTaken);

  BoardState.clean(BoardSetting setting) : this._(setting, {}, {});

  final Set<int> _xTaken;

  final Set<int> _oTaken;

  bool _isLocked = false;

  /// This is `true` if the board game is locked for the player.
  bool get isLocked => _isLocked;

  bool get hasOpenTiles {
    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        final owner = whoIsAt(Tile(x, y));
        if (owner == Owner.none) return true;
      }
    }
    return false;
  }

  Set<int> _selectSet(Owner owner) {
    switch (owner) {
      case Owner.x:
        return _xTaken;
      case Owner.o:
        return _oTaken;
      case Owner.none:
        throw ArgumentError.value(owner);
    }
  }

  void clearBoard() {
    _xTaken.clear();
    _oTaken.clear();
    _isLocked = false;

    notifyListeners();
  }

  Owner whoIsAt(Tile tile) {
    final pointer = tile.toPointer(setting);
    bool takenByX = _xTaken.contains(pointer);
    bool takenByO = _oTaken.contains(pointer);

    if (takenByX && takenByO) {
      throw StateError('The $tile at is taken by both X and Y.');
    }
    if (takenByX) {
      return Owner.x;
    } else if (takenByO) {
      return Owner.o;
    }
    return Owner.none;
  }

  void playerTakeTile(Tile tile, Owner who) {
    assert(!_isLocked);
    final pointer = tile.toPointer(setting);
    final set = _selectSet(who);
    set.add(pointer);
    _isLocked = true;
    notifyListeners();
  }

  void aiTakeTile(Tile tile, Owner who) {
    assert(_isLocked);
    final pointer = tile.toPointer(setting);
    final set = _selectSet(who);
    set.add(pointer);
    _isLocked = false;
    notifyListeners();
  }
}

enum Owner {
  x,
  o,
  none,
}
