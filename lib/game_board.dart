import 'dart:math';

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
  Position food = Position(column: 5, row: 5);
  Position obstacle = Position(column: 6, row: 6);

  @override
  void initState() {
    super.initState();
    generateFood();
    generateObstacle();
  }

  void generateFood() {
    // the function is to generate a random position for food
    int foodrow = Random().nextInt(widget.rows);
    int foodcolumn = Random().nextInt(widget.columns);
    food = Position(column: foodcolumn, row: foodrow);
  }

  void generateObstacle() {
    //the function is to generate a random position for the obstacle
    int obstaclerow = Random().nextInt(widget.rows);
    int obstaclecolumn = Random().nextInt(widget.columns);

    obstacle = Position(column: obstaclecolumn, row: obstaclerow);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.rows * widget.columns,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.columns,
      ),
      itemBuilder: (BuildContext context, int index) {
        // to check if the current index is part of the snake's body
        bool isSnake =
            snake.any((pos) => pos.row * widget.columns + pos.column == index);

        // to check if the current index is the food
        bool isFood = food.row * widget.columns + food!.column == index;

        // to check if the current index is the food
        bool isObstacle =
            obstacle!.row * widget.columns + obstacle!.column == index;

        // to return a Snake widget or an empty Container
        if (isSnake) {
          return Snake(snake: snake);
        } else if (isFood) {
          return const Food();
        } else if (isObstacle) {
          return const Obstacle();
        } else {
          return Container(
            color: Colors.grey[300],
            margin: const EdgeInsets.all(2),
          );
        }
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

class Food extends StatelessWidget {
  const Food({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: const EdgeInsets.all(2),
    );
  }
}

class Obstacle extends StatelessWidget {
  const Obstacle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      margin: const EdgeInsets.all(2),
    );
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
