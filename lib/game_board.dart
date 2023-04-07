import 'dart:math';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  final int rows;
  final int columns;

  const GameBoard({required this.rows, required this.columns, Key? key})
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

  Position foodPosition = Position(column: 5, row: 5);
  List<Position> obstaclePositions = [
    Position(column: 5, row: 5),
    Position(column: 5, row: 5)
  ];
  Direction _snakeDirection = Direction.right;
  int score = 0;
  bool _hasEaten = false;
  bool isGameOver = false;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    timer();
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
    obstaclePositions.add(obstacle);
  }

  void timer() {
    const duration = Duration(milliseconds: 200);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (!isGameOver) {
        move(_snakeDirection);
      } else {
        _timer.cancel();
      }
    });
  }

  void gameOver() {
    setState(() {
      isGameOver = true;
    });
    _timer.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score is $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      snake = [
        Position(column: 0, row: 0),
        Position(column: 0, row: 1),
        Position(column: 0, row: 2),
      ];
      score = 0;
      generateFood();
      generateObstacle();
      obstaclePositions = [];
    });
  }

  void move(Direction direction) {
    final newHead = snake.last.move(direction);

    // Check for collision with food
    if (newHead.row == foodPosition.row &&
        newHead.column == foodPosition.column) {
      setState(() {
        score++;
        _hasEaten = true;
        snake.add(newHead);
        generateFood();
      });
      return;
    }

    // Check for collision with obstacles
    final collidedWithObstacle = obstaclePositions.any(
      (pos) => pos.row == newHead.row && pos.column == newHead.column,
    );
    if (collidedWithObstacle) {
      gameOver();
      return;
    }

    setState(() {
      if (_hasEaten) {
        snake.add(newHead);
      } else {
        snake.removeAt(0);
        snake.add(newHead);
      }
    });
  }

  void onKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_snakeDirection != Direction.left) {
        _snakeDirection = Direction.right;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_snakeDirection != Direction.right) {
        _snakeDirection = Direction.left;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_snakeDirection != Direction.down) {
        _snakeDirection = Direction.up;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_snakeDirection != Direction.up) {
        _snakeDirection = Direction.down;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) => onKeyEvent(event),
      child: GridView.builder(
        itemCount: widget.rows * widget.columns,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.columns,
        ),
        itemBuilder: (BuildContext context, int index) {
          // to check if the current index is part of the snake's body
          bool isSnake = snake
              .any((pos) => pos.row * widget.columns + pos.column == index);

          // to check if the current index is the food
          bool isFood = food.row * widget.columns + food.column == index;

          // to check if the current index is the food
          bool isObstacle =
              obstacle.row * widget.columns + obstacle.column == index;

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
      ),
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
  final Direction? _direction;

  Position({
    required this.column,
    required this.row,
    Direction? direction,
  }) : _direction = direction;

  Position move(Direction direction) {
    final dx = direction == Direction.right
        ? 1
        : direction == Direction.left
            ? -1
            : 0;
    final dy = direction == Direction.down
        ? 1
        : direction == Direction.up
            ? -1
            : 0;
    final newColumn = column + dx;
    final newRow = row + dy;
    return Position(column: newColumn, row: newRow);
  }
}

class Direction {
  final int rowDelta;
  final int columnDelta;

  const Direction({required this.rowDelta, required this.columnDelta});

  static const left = Direction(rowDelta: 0, columnDelta: -1);
  static const up = Direction(rowDelta: -1, columnDelta: 0);
  static const right = Direction(rowDelta: 0, columnDelta: 1);
  static const down = Direction(rowDelta: 1, columnDelta: 0);
}
