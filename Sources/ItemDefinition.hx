package ;

import kha.math.Vector2i;
import kha.graphics2.Graphics;

class ItemDefinition {
    public var type: ItemType;
    public var spriteSheetPos: Vector2i;
    public var spriteSheetSize: Vector2i;
    var canBePlacedCallback: (where: Vector2i, map: TileMap) -> Bool;

    public function new(type: ItemType, spriteSheetPos: Vector2i, spriteSheetSize: Vector2i, canBePlacedCallback: (Vector2i, TileMap) -> Bool = null) {
        this.type = type;
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
        
        return canBePlacedCallback == null ? true : canBePlacedCallback(new Vector2i(x, y), map);
    }
}