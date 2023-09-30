package ;

import kha.math.Vector2i;
import kha.graphics2.Graphics;

class ItemType {
    public var name: String;
    public var spriteSheetPos: Vector2i;
    public var spriteSheetSize: Vector2i;

    public function new(name: String, spriteSheetPos: Vector2i, spriteSheetSize: Vector2i) {
        this.name = name;
        this.spriteSheetPos = spriteSheetPos;
        this.spriteSheetSize = spriteSheetSize;
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
}