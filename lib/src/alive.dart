library dartino_conway.alive;

/// The original, Conway's game of life.
AliveFunction gameOfLife =
    (int nc, bool isAlive) => nc == 3 || (nc == 2 && isAlive);

/// A cellular automaton that creates mazes.
AliveFunction gameOfLifeMaze = (int nc, bool isAlive) =>
    (nc == 1 || nc == 2 || nc == 3 || nc == 4 || nc == 5) && isAlive ||
    (nc == 3);

/// Another interesting automaton.
AliveFunction gameOfLifeMazectric = (int nc, bool isAlive) =>
    (nc == 1 || nc == 2 || nc == 3 || nc == 4) && isAlive || (nc == 3);

/// Definition of alive function for general cellular automata.
typedef bool AliveFunction(int neighborCount, bool isAlive);
