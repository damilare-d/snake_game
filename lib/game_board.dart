import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  final int rows;
  final int columns;

  GameBoard({required this.rows, required this.columns, Key? key})
      : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<Position> snake = [
    Position(column: 0, row: 0),
    Position(column: 0, row: 1),
    Position(column: 0, row: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.rows * widget.columns,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columns,
      ),
      itemBuilder: (BuildContext context, int index) {
        // Check if the current index is part of the snake's body
        bool isSnake =
            snake.any((pos) => pos.row * widget.columns + pos.column == index);

        // Return a Snake widget or an empty Container
        return isSnake
            ? Snake(snake: snake)
            : Container(
                color: Colors.grey[300], margin: const EdgeInsets.all(2));
      },
    );
  }
}

class Snake extends StatelessWidget {
  final List<Position> snake;

  const Snake({required this.snake});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green, margin: const EdgeInsets.all(2));
  }
}

class Position {
  int row;
  int column;

  Position({
    required this.column,
    required this.row,
  });
}
