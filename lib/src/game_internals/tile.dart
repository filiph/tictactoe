import 'package:flutter/cupertino.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';

@immutable
class Tile {
  final int x;
  final int y;
  const Tile(this.x, this.y);

  int toPointer(BoardSetting setting) {
    if (x < 0) throw ArgumentError.value(x, 'x');
    if (y < 0) throw ArgumentError.value(y, 'y');
    if (x >= setting.m) throw ArgumentError.value(x, 'x');
    if (y >= setting.n) throw ArgumentError.value(y, 'y');
    return y * setting.m + x;
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
