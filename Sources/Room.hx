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
    public var maxWidth: Int;
    public var maxHeight: Int;
    private var doorOffsets = [new Pos(0, 1), new Pos(1, 0), new Pos(0, -1), new Pos(-1, 0)];

    public function new(roomString: String) {
        var y = 0;
        var lines = roomString.split("\n");
        maxHeight = lines.length;

        for (line in lines) {
            var x = 0;
            maxWidth = line.length > maxWidth ? line.length : maxWidth;
            for (character in line.split("")) {
                var tile = switch (character) {
                    case ' ': Tile.Air;
                    case '#': Tile.Wall;
                    case '/': Tile.Door;
                    case '|': Tile.Rope;
                    case '_': Tile.Interior;
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

    public function stampOnMap(map: TileMap, x: Int, y: Int) {
        for (tile in tiles) {
            map.set(x + tile.x, y + tile.y, tile.tile);
        }
    }

    public function canBePlacedAtMap(map: TileMap, x: Int, y: Int) {
        for (tile in tiles) {
            if (map.get(x + tile.x, y + tile.y) != Tile.Air) {
                return false;
            }
        }
        return true;
    }

    public function getDoors() {
        return tiles.filter(tile -> tile.tile == Tile.Door);
    }

    // Returns the list of coords that this room could be placed at on the map,
    // such that a door of this room aligns with a door at the given door location
    public function attachmentsToDoor(map: TileMap, doorX: Int, doorY: Int) {
        var validAttachments = [];
        for (door in getDoors()) {
            for (doorOffset in doorOffsets) {
                if (canBePlacedAtMap(map, doorX - door.x - doorOffset.x, doorY - door.y - doorOffset.y)) {
                    validAttachments.push(new Pos(doorX - door.x - doorOffset.x, doorY - door.y - doorOffset.y));
                }
            }
        }
        return validAttachments;
    }
}