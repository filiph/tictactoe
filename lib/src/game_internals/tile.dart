import 'package:flutter/cupertino.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';

@immutable
class Tile {
  final int x;
  final int y;
  const Tile(this.x, this.y);

  int toPointer(BoardSetting setting) {
    if (!isValid(setting)) {
      throw ArgumentError.value(this, 'out of bounds of $setting');
    }
    return y * setting.m + x;
  }

  bool isValid(BoardSetting setting) {
    if (x < 0) return false;
    if (y < 0) return false;
    if (x >= setting.m) return false;
    if (y >= setting.n) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(Object other) {
    return other is Tile && other.x == x && other.y == y;
  }

  @override
  String toString() => 'Tile<$x:$y>';
}
