import 'package:flutter/foundation.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';

@immutable
class Score {
  final int score;

  final Duration duration;

  final int level;

  factory Score(
      int level, BoardSetting setting, int aiDifficulty, Duration duration) {
    var score = aiDifficulty * aiDifficulty;
    score *= setting.k * setting.k;
    score *= 1000 ~/ (duration.inSeconds.abs() + 1);
    return Score._(score, duration, level);
  }

  const Score._(this.score, this.duration, this.level);

  String get formattedTime {
    final buf = StringBuffer();
    if (duration.inHours > 0) {
      buf.write('${duration.inHours}');
      buf.write(':');
    }
    final minutes = duration.inMinutes % Duration.minutesPerHour;
    if (minutes > 9) {
      buf.write('$minutes');
    } else {
      buf.write('0');
      buf.write('$minutes');
    }
    buf.write(':');
    buf.write((duration.inSeconds % Duration.secondsPerMinute)
        .toString()
        .padLeft(2, '0'));
    return buf.toString();
  }

  @override
  String toString() => 'Score<$score,$formattedTime,$level>';
}
