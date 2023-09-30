package ;

import kha.graphics2.Graphics;

class GraphicsExtension {

    static public function drawTile(graphics: Graphics, tile: Tile, x: Int, y: Int) {
        graphics.drawSubImage(
            kha.Assets.images.spritesheet,
            x * Game.TILE_SIZE,
            y * Game.TILE_SIZE,
            tile.getIndex() * Game.TILE_SIZE,
            0,
            Game.TILE_SIZE,
            Game.TILE_SIZE
        );
    }
}