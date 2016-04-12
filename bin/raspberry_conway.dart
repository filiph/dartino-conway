library sample.conway;

import 'dart:dartino';
import 'dart:math';

import 'package:raspberry_pi/sense_hat.dart';
import 'package:dartino_conway/conway.dart';

main() {
  // Instantiate the Sense HAT API.
  final hat = new SenseHat();

  final random = new Random();

  var board = new Set();
  var previous = new Set();
  var dead = new Set();
  int worldAge = 0;

  void reset() {
    board.clear();
    for (int i = 0; i < CELL_COUNT; i++) {
      int x = random.nextInt(hat.ledArray.width);
      int y = random.nextInt(hat.ledArray.height);
      board.add(new Cell(x, y));
    }
    worldAge = 0;
  }

  void render(Iterable<Cell> board, Color color) {
    for (var cell in board) {
      hat.setPixel(cell.x, cell.y, color);
    }
  }

  hat.clear(EMPTY_COLOR);

  while (true) {
    render(dead, EMPTY_COLOR);
    render(board, LIVING_COLOR);
    var next = step(board, gameOfLife);
    var born = next.difference(board);
    dead = board.difference(next);
    render(born, BORN_COLOR);
    render(dead, DYING_COLOR);
    if (worldAge > MAX_WORLD_AGE) {
      print("World too old. Reset.");
      reset();
    } else if (born.isEmpty && dead.isEmpty) {
      print("Stale. Reset.");
      reset();
    } else if (next.containsAll(previous) && previous.containsAll(next)) {
      print("Repetitive. Reset.");
      reset();
    } else {
      previous = board;
      board = next;
      worldAge += 1;
    }
    sleep(1000 ~/ GENERATIONS_PER_SECOND);
  }
}

const BORN_COLOR = const Color(0, 0xCC, 0);
const CELL_COUNT = 20;
const DYING_COLOR = const Color(0x66, 0, 0);
const EMPTY_COLOR = Color.black;
const GENERATIONS_PER_SECOND = 10;
const LIVING_COLOR = Color.white;
const MAX_WORLD_AGE = 200;
