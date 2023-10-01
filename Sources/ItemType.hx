package ;

import kha.math.Vector2i;
import kha.graphics2.Graphics;

enum Item {
    Mushroom;
}

class ItemType {
    public var name: String;
    public var spriteSheetPos: Vector2i;
    public var spriteSheetSize: Vector2i;
    var canBePlacedCallback: (where: Vector2i) -> Bool;

    public function new(name: String, spriteSheetPos: Vector2i, spriteSheetSize: Vector2i, canBePlacedCallback: (where: Vector2i) -> Bool = null) {
        this.name = name;
        this.spriteSheetPos = spriteSheetPos;
        this.spriteSheetSize = spriteSheetSize;
        this.canBePlacedCallback = canBePlacedCallback;
    }

    public function render(g: Graphics, x: Int, y: Int) {
        g.drawSubImage(
            kha.Assets.images.spritesheet,
            x,
            y,
            spriteSheetPos.x * Game.TILE_SIZE,
            spriteSheetPos.y * Game.TILE_SIZE,
            spriteSheetSize.x * Game.TILE_SIZE,
            spriteSheetSize.y * Game.TILE_SIZE
        );
    }

    public function canBePlacedAtMap(map: TileMap, x: Int, y: Int) {
        // Base constraint: all sprite tiles should be free room interiors
        for (dy in 0...spriteSheetSize.y) {
            for (dx in 0...spriteSheetSize.x) {
                if (
                    map.get(x + dx, y + dy) != Tile.Interior ||
                    map.getItem(new Vector2i(x + dx, y + dy)) != null
                ) {
                    return false;
                }
            }
        }
        
        return canBePlacedCallback == null ? true : canBePlacedCallback(new Vector2i(x, y));
    }
}