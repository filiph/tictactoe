import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

class BoardState extends ChangeNotifier {
  static final Logger _log = Logger('BoardState');

  final BoardSetting setting;

  final AiOpponent aiOpponent;

  final Set<int> _xTaken;

  final Set<int> _oTaken;

  Tile? _latestXTile;

  Tile? _latestOTile;

  bool _isLocked = true;

  final ChangeNotifier playerWon = ChangeNotifier();

  final ChangeNotifier aiOpponentWon = ChangeNotifier();

  List<Tile>? _winningLine;

  BoardState.clean(BoardSetting setting, AiOpponent aiOpponent)
      : this._(setting, {}, {}, aiOpponent, null, null);

  @visibleForTesting
  BoardState.withExistingState({
    required BoardSetting setting,
    required AiOpponent aiOpponent,
    required Set<int> takenByX,
    required Set<int> takenByO,
    Tile? latestX,
    Tile? latestO,
  }) : this._(setting, takenByX, takenByO, aiOpponent, latestX, latestO);

  BoardState._(this.setting, this._xTaken, this._oTaken, this.aiOpponent,
      this._latestXTile, this._latestOTile);

  /// This is `true` if the board game is locked for the player.
  bool get isLocked => _isLocked;

  Iterable<Tile>? get winningLine => _winningLine;

  Iterable<Tile> get _allTakenTiles =>
      _allTiles.where((tile) => whoIsAt(tile) != Side.none);

  Iterable<Tile> get _allTiles sync* {
    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        yield Tile(x, y);
      }
    }
  }

  bool get _hasOpenTiles {
    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        final owner = whoIsAt(Tile(x, y));
        if (owner == Side.none) return true;
      }
    }
    return false;
  }

  /// Returns true if this tile can be taken by the player.
  bool canTake(Tile tile) {
    return whoIsAt(tile) == Side.none;
  }

  void clearBoard() {
    _xTaken.clear();
    _oTaken.clear();
    _winningLine?.clear();
    _latestXTile = null;
    _latestOTile = null;
    _isLocked = true;

    notifyListeners();
  }

  void initialize() {
    _oTaken.addAll(_generateInitialOTaken());
    _isLocked = false;

    notifyListeners();
  }

  @override
  void dispose() {
    playerWon.dispose();
    aiOpponentWon.dispose();
    super.dispose();
  }

  Tile? getLatestTileForSide(Side side) {
    if (side == Side.x) {
      return _latestXTile;
    }
    if (side == Side.o) {
      return _latestOTile;
    }
    return null;
  }

  Iterable<Tile> getNeighborhood(Tile tile) sync* {
    for (var dx = -1; dx <= 1; dx++) {
      for (var dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) {
          // Same tile as [tile], skipping.
          continue;
        }
        final x = tile.x + dx;
        final y = tile.y + dy;
        if (x < 0) continue;
        if (y < 0) continue;
        if (x >= setting.m) continue;
        if (y >= setting.n) continue;
        yield Tile(x, y);
      }
    }
  }

  /// Returns all valid lines going through [tile].
  Iterable<List<Tile>> getValidLinesThrough(Tile tile) sync* {
    // Horizontal lines.
    for (var startX = tile.x - setting.k + 1; startX <= tile.x; startX++) {
      final startTile = Tile(startX, tile.y);
      if (!startTile.isValid(setting)) continue;
      final endTile = Tile(startTile.x + setting.k - 1, tile.y);
      if (!endTile.isValid(setting)) continue;
      yield [for (var i = startTile.x; i <= endTile.x; i++) Tile(i, tile.y)];
    }

    // Vertical lines.
    for (var startY = tile.y - setting.k + 1; startY <= tile.y; startY++) {
      final startTile = Tile(tile.x, startY);
      if (!startTile.isValid(setting)) continue;
      final endTile = Tile(tile.x, startTile.y + setting.k - 1);
      if (!endTile.isValid(setting)) continue;
      yield [for (var i = startTile.y; i <= endTile.y; i++) Tile(tile.x, i)];
    }

    // Downward diagonal lines.
    for (var xOffset = -setting.k + 1; xOffset <= 0; xOffset++) {
      var yOffset = xOffset;
      final startTile = Tile(tile.x + xOffset, tile.y + yOffset);
      if (!startTile.isValid(setting)) continue;
      final endTile =
          Tile(startTile.x + setting.k - 1, startTile.y + setting.k - 1);
      if (!endTile.isValid(setting)) continue;
      yield [
        for (var i = 0; i < setting.k; i++)
          Tile(startTile.x + i, startTile.y + i)
      ];
    }

    // Upward diagonal lines.
    for (var xOffset = -setting.k + 1; xOffset <= 0; xOffset++) {
      var yOffset = -xOffset;
      final startTile = Tile(tile.x + xOffset, tile.y + yOffset);
      if (!startTile.isValid(setting)) continue;
      final endTile =
          Tile(startTile.x + setting.k - 1, startTile.y - setting.k + 1);
      if (!endTile.isValid(setting)) continue;
      yield [
        for (var i = 0; i < setting.k; i++)
          Tile(startTile.x + i, startTile.y - i)
      ];
    }
  }

  /// Take [tile] with player's token.
  void take(Tile tile) async {
    _log.info(() => 'taking $tile');
    assert(canTake(tile));
    assert(!_isLocked);

    _takeTile(tile, setting.playerSide);
    _isLocked = true;

    final playerJustWon = _getWinner() == setting.playerSide;

    if (playerJustWon) {
      // Player won with this move.
      playerWon.notifyListeners();
    }

    notifyListeners();

    if (!playerJustWon && _hasOpenTiles) {
      // Time for AI to move.
      await Future.delayed(const Duration(milliseconds: 300));
      assert(_isLocked);
      assert(
          _hasOpenTiles, 'Somehow, tiles got taken while waiting for AI turn');
      final tile = aiOpponent.chooseNextMove(this);
      _takeTile(tile, setting.aiOpponentSide);

      if (_getWinner() == setting.aiOpponentSide) {
        // Player won with this move.
        aiOpponentWon.notifyListeners();
      } else {
        // Play continues.
        _isLocked = false;
      }

      notifyListeners();
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

  /// Returns `null` if nobody has yet won this board. Otherwise, returns
  /// the winner.
  ///
  /// If somehow both parties are winning, then the behavior of this method
  /// is undefined.
  ///
  /// As a side-effect, this function sets [winningLine] if found.
  ///
  /// This function might take some time on bigger boards to evaluate.
  Side? _getWinner() {
    for (final tile in _allTakenTiles) {
      // TODO: instead of checking each tile, check each valid line just once
      for (final validLine in getValidLinesThrough(tile)) {
        final owner = whoIsAt(validLine.first);
        if (owner == Side.none) continue;
        if (validLine.every((tile) => whoIsAt(tile) == owner)) {
          _winningLine = validLine;
          return owner;
        }
      }
    }

    return null;
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

  void _takeTile(Tile tile, Side side) {
    final pointer = tile.toPointer(setting);
    final set = _selectSet(side);
    set.add(pointer);
    if (side == Side.x) {
      _latestXTile = tile;
    } else if (side == Side.o) {
      _latestOTile = tile;
    }
  }

  Set<int> _generateInitialOTaken() {
    assert(setting.aiOpponentSide == Side.o, "Unimplemented: AI plays as X");

    if (setting.aiStarts) {
      final tile = Tile((setting.m / 2).floor(), (setting.n ~/ 2).floor());
      return {
        tile.toPointer(setting),
      };
    } else {
      return {};
    }
  }
}

enum Side {
  x,
  o,
  none,
}
