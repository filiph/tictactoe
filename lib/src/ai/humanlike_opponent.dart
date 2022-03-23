import 'package:logging/logging.dart';
import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

/// An AI that doesn't look ahead, and only scores tiles.
///
/// It makes moves that are similar to what a human player might make.
class HumanlikeOpponent extends AiOpponent {
  static final _log = Logger('HumanlikeOpponent');

  /// The relative weight the AI gives to own "plans". A stubborn AI will go
  /// ahead with its own k-in-a-row line despite the fact it should be defending
  /// against the opponents line instead.
  ///
  /// Should be between `0` and `1`, and probably closer to zero.
  final double stubbornness;

  /// The strength of the AI. The smaller this number is, the stronger the
  /// options from which the AI will choose its next move.
  ///
  /// Setting this to `1` means the AI only takes the best computer move.
  /// Setting this to `100` means it will only be directed by "humanlike"
  /// analysis.
  final int bestPlayCount;

  /// The human-ness of the AI. The lower the number, the more "humanlike"
  /// the options from which the AI will choose its next move.
  ///
  /// Setting this to `1` means the AI only takes the most humanlike move.
  /// Setting this to `100` means the AI will play moves only according to
  /// the "best play" (computer) analysis.
  final int humanlikePlayCount;

  @override
  final String name;

  /// Same as [playerScoring], but this time we're scoring the AI's
  /// own tiles.
  final List<int> aiScoring;

  /// Scores corresponding to a given number of taken tiles.
  ///
  /// The default values are:
  ///
  ///     const [1, 20, 90, 400, 8000, 0]
  ///
  /// For example, if a run of `k` tiles has 3 player tiles in it,
  /// it will be scored with `400`. If it has 0 player tiles in it,
  /// it will be scored with `1`.
  final List<int> playerScoring;

  HumanlikeOpponent(
    BoardSetting setting, {
    required this.name,
    this.humanlikePlayCount = 2,
    this.bestPlayCount = 5,
    this.stubbornness = 0.05,
    this.playerScoring = const [1, 20, 90, 400, 8000, 0],
    this.aiScoring = const [2, 30, 100, 500, 10000, 0],
  })  : assert(stubbornness <= 1),
        assert(stubbornness >= 0),
        assert(humanlikePlayCount >= 1),
        assert(bestPlayCount >= 1),
        super(setting) {
    assert(
        setting.k <= playerScoring.length + 1,
        'Scoring opponent does not support games '
        'with more than 5 in a row');
    assert(
        setting.k <= aiScoring.length + 1,
        'Scoring opponent does not support games '
        'with more than 5 in a row');
  }

  @override
  Tile chooseNextMove(BoardState state) {
    final scores = <_TileScore>[];

    final latestPlayerTile = state.getLatestTileForSide(setting.playerSide);
    final latestAiTile = state.getLatestTileForSide(setting.aiOpponentSide);

    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        final tile = Tile(x, y);

        if (state.whoIsAt(tile) != Side.none) {
          continue;
        }

        final score = _TileScore(tile);

        for (final neighbor in state.getNeighborhood(tile)) {
          if (latestPlayerTile == neighbor) {
            score.humanlikePlay += 50;
          }

          if (latestAiTile == neighbor) {
            score.humanlikePlay += (50 * stubbornness).round();
          }
        }

        for (final line in state.getValidLinesThrough(tile)) {
          if (line.contains(latestPlayerTile)) {
            // Humans love to play where the opponent just played.
            score.humanlikePlay += 50;
          }

          if (line.contains(latestAiTile)) {
            // Humans also love to play where they played last.
            score.humanlikePlay += (50 * stubbornness).round();
          }

          var aiTiles = line
              .where((tile) => state.whoIsAt(tile) == setting.aiOpponentSide)
              .length;
          var playerTiles = line
              .where((tile) => state.whoIsAt(tile) == setting.playerSide)
              .length;

          // Humans love to play where their other marks already are.
          score.humanlikePlay += aiTiles;

          if (aiTiles > 0 && playerTiles > 0) {
            // Lost cause. Both sides have their tokens here.
            // Cannot make a line.
            // Still, a human-like opponent will go for it anyway if there's
            // any friendly tiles.
            score.humanlikePlay += (100 * stubbornness).round();
            continue;
          }

          if (aiTiles == 0) {
            // Any player tiles should score towards best play.
            score.bestPlay += playerScoring[playerTiles];
            if (tile == line.first || tile == line.last) {
              if (playerTiles == setting.k - 1) {
                score.humanlikePlay += 300;
              } else if (playerTiles == setting.k - 2) {
                score.humanlikePlay += 200;
              }
            }
          }

          if (playerTiles == 0) {
            // Any AI tiles should score towards best play.
            score.bestPlay += aiScoring[aiTiles];
            if (tile == line.first || tile == line.last) {
              if (aiTiles == setting.k - 1) {
                score.humanlikePlay += 100;
              } else if (aiTiles == setting.k - 2) {
                score.humanlikePlay += 50;
              }
            }
          }
        }

        scores.add(score);
      }
    }

    // The options, sorted from the best play perspective...
    final bestPlay = List.of(scores)
      ..sort((a, b) => -a.bestPlay.compareTo(b.bestPlay));
    if (scores.length > bestPlayCount) {
      // ... and truncated to just the percentile we want.
      bestPlay.removeRange(bestPlayCount, scores.length);
    }

    // The options, sorted from the "humanlike" play perspective.
    final humanlike = List.of(scores)
      ..sort((a, b) => -a.humanlikePlay.compareTo(b.humanlikePlay));

    var defaultBest = true;
    _TileScore best =
        (humanlikePlayCount < bestPlayCount) ? humanlike.first : bestPlay.first;
    for (var i = 0; i <= humanlikePlayCount; i++) {
      final candidate = humanlike[i];
      if (bestPlay.contains(candidate)) {
        // Found the most "obvious" tile that's also among the best choices.
        best = candidate;
        defaultBest = false;
        break;
      }
    }

    if (defaultBest) {
      _log.warning("We didn't find any tile that would be both in "
          "best play percentile of $bestPlayCount and humanlike play "
          "percentile of $humanlikePlayCount. Chose $best.");
    }

    return best.tile;
  }
}

class _TileScore {
  final Tile tile;

  int bestPlay = 0;

  int humanlikePlay = 0;

  double? finalScore;

  _TileScore(this.tile);

  @override
  String toString() {
    return "_TileScore<$tile:bestPlay=$bestPlay:humanlike=$humanlikePlay"
        ":final=${(finalScore ?? -1).toStringAsFixed(2)}>";
  }
}
