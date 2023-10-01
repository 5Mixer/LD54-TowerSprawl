package ;

import kha.math.Vector2i;
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
            g.drawMiniTile(tile.tile, tile.x * Game.PREVIEW_TILE_SIZE + x, tile.y * Game.PREVIEW_TILE_SIZE + y);
        }
        g.color = Color.White;
    }

    public function stampOnMap(map: TileMap, x: Int, y: Int, real = false) {
        for (tile in tiles) {
            var existingTile = map.get(x + tile.x, y + tile.y);
            if (tile.tile != Tile.Air && !(existingTile == Tile.Wall && tile.tile == Tile.Door))
                map.set(x + tile.x, y + tile.y, tile.tile, real);
        }
    }

    public function canBePlacedAtMap(map: TileMap, x: Int, y: Int) {
        // No non-air, non-door tiles should change as a result of the placement
        for (tile in tiles) {
            if (tile.tile == Tile.Air || tile.tile == Tile.Door) continue;

            var existingTile = map.get(x + tile.x, y + tile.y, false);
            if (existingTile == Tile.Air || existingTile == Tile.Door) continue;
            
            if (existingTile != tile.tile) {
                return false;
            }
        }

        // A door should overlap between the rooms
        for (door in getDoors()) {
            if (map.get(door.x + x, door.y + y, false) == Tile.Door) {
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
                validAttachments.push(new Vector2i(doorX - door.x, doorY - door.y));
            }
        }
        return validAttachments;
    }
}