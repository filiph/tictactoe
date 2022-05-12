import 'package:flutter/material.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/play_session/board_tile.dart';
import 'package:tictactoe/src/play_session/rough_grid.dart';

class Board extends StatefulWidget {
  final VoidCallback? onPlayerWon;

  const Board({super.key, required this.setting, this.onPlayerWon});

  final BoardSetting setting;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.setting.m / widget.setting.n,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RoughGrid(widget.setting.m, widget.setting.n),
          Column(
            children: [
              for (var y = 0; y < widget.setting.n; y++)
                Expanded(
                  child: Row(
                    children: [
                      for (var x = 0; x < widget.setting.m; x++)
                        Expanded(
                          child: BoardTile(Tile(x, y)),
                        ),
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
