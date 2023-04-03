import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'game_board.dart';

class Snake extends StatelessWidget {
  List<Position> snake;
  Snake({required this.snake, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: snake
          .map((pos) => Positioned(
              top: pos.row * 24,
              left: pos.column * 24,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  shape: BoxShape.circle,
                ),
              )))
          .toList(),
    );
  }
}
