package ;

import kha.Assets;
import kha.graphics2.Graphics;
import kha.math.Vector2i;

class Minion {
    var pos: Vector2i;

    public function new(pos: Vector2i) {
        this.pos = pos;
    }

    public function render(g: Graphics) {
        g.drawSubImage(
            Assets.images.spritesheet,
            pos.x * Game.TILE_SIZE,
            pos.y * Game.TILE_SIZE,
            0,
            2 * Game.TILE_SIZE,
            Game.TILE_SIZE,
            Game.TILE_SIZE
        );
    }

    public function update() {

    }
}