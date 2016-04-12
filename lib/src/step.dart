library dartino_conway.step;

import 'package:dartino_conway/conway.dart';

/// One step in Game of Life.
Set<Cell> step(Set<Cell> board, AliveFunction shouldBeAlive) {
  final Map<Cell, int> neighborCount = board
      // For each cell, get its neighbors.
      .map((p) => p.neighbors)
      // Flatten the List of Sets into one long Iterable.
      .expand((p) => p)
      // Count occurences of each cell.
      .fold({}, (Map<Cell, int> map, p) {
    map[p] = map.putIfAbsent(p, () => 0) + 1;
    return map;
  });

  return neighborCount.keys
      // Apply the cellular automaton function to each cell to find out if
      // it should be alive.
      .where((Cell p) => shouldBeAlive(neighborCount[p], board.contains(p)))
      .toSet();
}
