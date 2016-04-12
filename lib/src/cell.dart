library dartino_conway.cell;

/// Cell definition for Game of Life. The board is a torus (edges wrap around).
class Cell {
  /// Position of the cell.
  int x, y;

  /// Width and height of the board this cell is a part of.
  final int boardWidth, boardHeight;

  Cell(int x, int y, [int boardWidth = 8, int boardHeight = 8])
      : x = x % boardWidth,
        y = y % boardHeight,
        boardWidth = boardWidth,
        boardHeight = boardHeight;

  int get hashCode => (x << 8) + y;

  /// Build a set of neighbors of the given cell.
  Set<Cell> get neighbors {
    // A list of differentials which will be applied in each of the
    // two dimensions.
    const dl = const [-1, 0, 1];
    return dl
        // Create all combinations of dx and dy, then create the cells of given
        // offset.
        .expand((dx) => dl.map((dy) => offset(dx, dy)))
        // Remove the original cell.
        .where((np) => np != this)
        .toSet();
  }

  operator ==(other) => hashCode == other.hashCode;

  /// Get a representation of a cell whose position is offset by [dx] and [dy].
  Cell offset(int dx, int dy) =>
      new Cell(x + dx, y + dy, boardWidth, boardHeight);

  toString() => "($x, $y)";
}
