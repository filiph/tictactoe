import 'package:flutter/foundation.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';

/// The setting of an m,n,k-game.
///
/// For example, the Japanese game gomoku is a 15,15,5-game.
/// Tic Tac Toe is a 3,3,3-game.
@immutable
class BoardSetting {
  /// The number of columns. The "width" of the game board.
  final int m;

  /// The number of rows. The "height" of the game board.
  final int n;

  /// The number of tiles in a row needed to win.
  final int k;

  /// Which side is the player taking?
  final Side playerSide;

  /// If `true`, the board will start with an `aiOpponentSide` mark in
  /// the center.
  final bool aiStarts;

  const BoardSetting(this.m, this.n, this.k,
      {this.playerSide = Side.x, this.aiStarts = false});

  Side get aiOpponentSide => playerSide == Side.x ? Side.o : Side.x;

  @override
  int get hashCode => Object.hash(m, n, k);

  @override
  bool operator ==(Object other) {
    return other is BoardSetting &&
        other.m == m &&
        other.n == n &&
        other.k == k;
  }
}
