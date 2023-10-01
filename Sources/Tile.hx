package ;

enum Tile {
    Air;
    Wall;
    Door;
    Rope;
    Interior;
    Debug;
}

class MapTile {
    public var tile: Tile;
    public var real: Bool;

    public function new(tile: Tile, real: Bool = true) {
        this.tile = tile;
        this.real = real;
    }
}

function isSolid(tile: Tile) {
    return tile == Tile.Wall || tile == Tile.Air; // Used for pathfinding
}
