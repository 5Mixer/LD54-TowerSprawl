package ;

import kha.Color;
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
    public function renderSmall(g: Graphics, x, y) {
        var scale = 2;
        for (tile in tiles) {
            g.color = switch(tile.tile) {
                case Tile.Air: Color.Transparent;
                case Tile.Wall: Color.fromBytes(93, 97, 96);
                case Tile.Door: Color.fromBytes(193, 108, 106);
                case Tile.Rope: Color.fromBytes(193, 168, 146);
                case Tile.Interior: Color.fromBytes(200, 200, 200, 100);
            }
            g.fillRect((tile.x + x) * scale, (tile.y + y) * scale, scale, scale);
        }
        g.color = Color.White;
    }

    public function stampOnMap(map: TileMap, x: Int, y: Int) {
        for (tile in tiles) {
            if (tile.tile != Tile.Air)
                map.set(x + tile.x, y + tile.y, tile.tile);
        }
    }

    public function canBePlacedAtMap(map: TileMap, x: Int, y: Int) {
        // No non-air tiles should change as a result of the placement
        for (tile in tiles) {
            if (tile.tile == Tile.Air) continue;

            var existingTile = map.get(x + tile.x, y + tile.y);
            if (existingTile != Tile.Air && existingTile != tile.tile) {
                return false;
            }
        }

        // A door should overlap between the rooms
        for (door in getDoors()) {
            if (map.get(door.x + x, door.y + y) == Tile.Door) {
                return true;
            }
        }
        
        return false;
    }

    public function getDoors() {
        return tiles.filter(tile -> tile.tile == Tile.Door);
    }

    // Returns the list of coords that this room could be placed at on the map,
    // such that a door of this room aligns with a door at the given door location
    public function attachmentsToDoor(map: TileMap, doorX: Int, doorY: Int) {
        var validAttachments = [];
        for (door in getDoors()) {
            if (canBePlacedAtMap(map, doorX - door.x, doorY - door.y)) {
                validAttachments.push(new Pos(doorX - door.x, doorY - door.y));
            }
        }
        return validAttachments;
    }
}