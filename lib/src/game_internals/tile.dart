import 'package:flutter/foundation.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';

@immutable
class Tile {
  final int x;
  final int y;

  const Tile(this.x, this.y);

  factory Tile.fromPointer(int pointer, BoardSetting setting) {
    final y = pointer ~/ setting.m;
    final x = pointer % setting.m;
    return Tile(x, y);
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(Object other) {
    return other is Tile && other.x == x && other.y == y;
  }

  bool isValid(BoardSetting setting) {
    if (x < 0) return false;
    if (y < 0) return false;
    if (x >= setting.m) return false;
    if (y >= setting.n) return false;
    return true;
  }

  int toPointer(BoardSetting setting) {
    if (!isValid(setting)) {
      throw ArgumentError.value(this, 'out of bounds of $setting');
    }
    return y * setting.m + x;
  }

  @override
  String toString() => 'Tile<$x:$y>';
}
