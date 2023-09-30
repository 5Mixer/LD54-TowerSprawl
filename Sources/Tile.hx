package ;

enum Tile {
    Air;
    Wall;
    Door;
    Rope;
    Interior;
    Debug;
}

function isSolid(tile: Tile) {
    return tile == Tile.Wall || tile == Tile.Air; // Used for pathfinding
}
