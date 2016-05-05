// Copyright (c) 2016, the Dartino project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE.md file.

import 'package:stm32f746g_disco/lcd.dart';
import 'package:stm32f746g_disco/stm32f746g_disco.dart';

import 'dart:dartino';
import 'dart:math';

import 'package:dartino_conway/conway.dart';

main() {
  STM32F746GDiscovery disco = new STM32F746GDiscovery();
  FrameBuffer surface = disco.frameBuffer;

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
      surface.drawLine(cell.x, cell.y, cell.x, cell.y, color);
    }
  }

  surface.clear(Color.black);

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

// Entry point.
const MAX_WORLD_AGE = 200;

class MovablePoint {
  final int x, y;
  int mx, my;

  MovablePoint(this.x, this.y, this.mx, this.my);

  getNextPoint(FrameBuffer surface) {
    int newX = x + mx;
    int newMX = mx;
    if (newX < 0 || newX >= surface.width) {
      newMX = -mx;
      newX = x + newMX;
    }
    int newY = y + my;
    int newMY = my;
    if (newY < 0 || newY >= surface.height) {
      newMY = -my;
      newY = y + newMY;
    }

    return new MovablePoint(newX, newY, newMX, newMY);
  }
}

class MovableLine {
  MovablePoint a, b;
  final Color color;

  MovableLine(this.a, this.b, this.color);

  getNextLine(FrameBuffer surface) {
    return new MovableLine(
        a.getNextPoint(surface), b.getNextPoint(surface), color);
  }

  draw(FrameBuffer surface) {
    surface.drawLine(a.x, a.y, b.x, b.y, color);
  }

  erase(FrameBuffer surface) {
    surface.drawLine(a.x, a.y, b.x, b.y, Color.black);
  }
}
