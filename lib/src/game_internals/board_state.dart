import 'package:flutter/cupertino.dart';
import 'package:flutter_game_sample/src/game_internals/ai_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';
import 'package:logging/logging.dart';

class BoardState extends ChangeNotifier {
  final BoardSetting setting;

  final AiOpponent aiOpponent;

  BoardState._(this.setting, this._xTaken, this._oTaken, this.aiOpponent);

  BoardState.clean(BoardSetting setting, AiOpponent aiOpponent)
      : this._(setting, {}, {}, aiOpponent);

  final Set<int> _xTaken;

  final Set<int> _oTaken;

  bool _isLocked = false;

  /// This is `true` if the board game is locked for the player.
  bool get isLocked => _isLocked;

  bool get hasOpenTiles {
    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        final owner = whoIsAt(Tile(x, y));
        if (owner == Side.none) return true;
      }
    }
    return false;
  }

  Set<int> _selectSet(Side owner) {
    switch (owner) {
      case Side.x:
        return _xTaken;
      case Side.o:
        return _oTaken;
      case Side.none:
        throw ArgumentError.value(owner);
    }
  }

  void clearBoard() {
    _xTaken.clear();
    _oTaken.clear();
    _isLocked = false;

    notifyListeners();
  }

  /// Returns `null` if nobody has yet won this board. Otherwise, returns
  /// the winner.
  ///
  /// If somehow both parties are winning, then the behavior of this method
  /// is undefined.
  ///
  /// This is a function and not a getter merely because it might take some
  /// time on bigger boards to evaluate.
  Side? getWinner() {
    for (final tile in allTakenTiles) {
      // TODO: instead of checking each tile, check each valid line just once
      for (final validLine in getValidLinesThrough(tile)) {
        final owner = whoIsAt(validLine.first);
        if (owner == Side.none) continue;
        if (validLine.every((tile) => whoIsAt(tile) == owner)) {
          return owner;
        }
      }
    }

    return null;
  }

  Iterable<Tile> get allTiles sync* {
    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        yield Tile(x, y);
      }
    }
  }

  Iterable<Tile> get allTakenTiles =>
      allTiles.where((tile) => whoIsAt(tile) != Side.none);

  /// Returns all valid lines going through [tile].
  Iterable<Set<Tile>> getValidLinesThrough(Tile tile) sync* {
    // Horizontal lines.
    for (var startX = tile.x - setting.m + 1; startX <= tile.x; startX++) {
      final startTile = Tile(startX, tile.y);
      if (!startTile.isValid(setting)) continue;
      final endTile = Tile(startTile.x + setting.k - 1, tile.y);
      if (!endTile.isValid(setting)) continue;
      yield {for (var i = startTile.x; i <= endTile.x; i++) Tile(i, tile.y)};
    }

    // Vertical lines.
    for (var startY = tile.y - setting.n + 1; startY <= tile.y; startY++) {
      final startTile = Tile(tile.x, startY);
      if (!startTile.isValid(setting)) continue;
      final endTile = Tile(tile.x, startTile.y + setting.k - 1);
      if (!endTile.isValid(setting)) continue;
      yield {for (var i = startTile.y; i <= endTile.y; i++) Tile(tile.x, i)};
    }

    // Downward diagonal lines.
    for (var xOffset = -setting.m + 1; xOffset <= 0; xOffset++) {
      var yOffset = xOffset;
      final startTile = Tile(tile.x + xOffset, tile.y + yOffset);
      if (!startTile.isValid(setting)) continue;
      final endTile =
          Tile(startTile.x + setting.k - 1, startTile.y + setting.k - 1);
      if (!endTile.isValid(setting)) continue;
      yield {
        for (var i = 0; i < setting.k; i++)
          Tile(startTile.x + i, startTile.y + i)
      };
    }

    // Upward diagonal lines.
    for (var xOffset = -setting.m + 1; xOffset <= 0; xOffset++) {
      var yOffset = -xOffset;
      final startTile = Tile(tile.x + xOffset, tile.y + yOffset);
      if (!startTile.isValid(setting)) continue;
      final endTile =
          Tile(startTile.x + setting.k - 1, startTile.y - setting.k + 1);
      if (!endTile.isValid(setting)) continue;
      yield {
        for (var i = 0; i < setting.k; i++)
          Tile(startTile.x + i, startTile.y - i)
      };
    }
  }

  @override
  void dispose() {
    playerWon.dispose();
    super.dispose();
  }

  final ChangeNotifier playerWon = ChangeNotifier();

  final ChangeNotifier aiOpponentWon = ChangeNotifier();

  /// Returns true if this tile can be taken by the player.
  bool canTake(Tile tile) {
    return whoIsAt(tile) == Side.none;
  }

  static final Logger _log = Logger('BoardState');

  /// Take [tile] with player's token.
  void take(Tile tile) async {
    _log.info(() => 'taking $tile');
    assert(canTake(tile));
    assert(!_isLocked);

    _takeTile(tile, setting.playerSide);
    _isLocked = true;
    notifyListeners();

    if (getWinner() == setting.playerSide) {
      // Player won with this move.
      playerWon.notifyListeners();
      return;
    }

    if (hasOpenTiles) {
      // Time for AI to move.
      await Future.delayed(const Duration(milliseconds: 300));
      assert(_isLocked);
      assert(
          hasOpenTiles, 'Somehow, tiles got taken while waiting for AI turn');
      final tile = aiOpponent.chooseNextMove(this);
      _takeTile(tile, setting.aiOpponentSide);
      _isLocked = false;
      notifyListeners();

      if (getWinner() == setting.aiOpponentSide) {
        // Player won with this move.
        aiOpponentWon.notifyListeners();
        return;
      }
    }
  }

  Side whoIsAt(Tile tile) {
    final pointer = tile.toPointer(setting);
    bool takenByX = _xTaken.contains(pointer);
    bool takenByO = _oTaken.contains(pointer);

    if (takenByX && takenByO) {
      throw StateError('The $tile at is taken by both X and Y.');
    }
    if (takenByX) {
      return Side.x;
    } else if (takenByO) {
      return Side.o;
    }
    return Side.none;
  }

  void _takeTile(Tile tile, Side side) {
    final pointer = tile.toPointer(setting);
    final set = _selectSet(side);
    set.add(pointer);
  }
}

enum Side {
  x,
  o,
  none,
}
