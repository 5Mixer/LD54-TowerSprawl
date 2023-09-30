package ;

import kha.graphics2.Graphics;
using GraphicsExtension;

class PositionedTile {
    public var tile: Tile;
    public var x: Int;
    public var y: Int;

    public function new (tile: Tile, x: Int, y: Int) {
        this.tile = tile;
        this.x = x;
        this.y = y;
    }
}

class Room {
    var tiles: Array<PositionedTile> = [];
    public function new(roomString: String) {
        var y = 0;
        for (line in roomString.split("\n")) {
            var x = 0;
            for (character in line.split("")) {
                var tile = switch (character) {
                    case ' ': Tile.Air;
                    case '#': Tile.Wall;
                    case '/': Tile.Door;
                    case '|': Tile.Rope;
                    default: throw 'Unhandled character $character';
                }
                tiles.push(new PositionedTile(tile, x, y));
                
                x++;
            }
            y++;
        }
    }

    public function render(g: Graphics, x, y) {
        for (tile in tiles) {
            g.drawTile(tile.tile, tile.x + x, tile.y + y);
        }
    }
}