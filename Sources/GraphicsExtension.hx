package ;

import kha.graphics2.Graphics;

class GraphicsExtension {
    private static var tileSize = 8;

    static public function drawTile(graphics: Graphics, tile: Tile, x: Int, y: Int) {
        graphics.drawSubImage(
            kha.Assets.images.spritesheet,
            x * tileSize,
            y * tileSize,
            tile.getIndex() * tileSize,
            0,
            tileSize,
            tileSize
        );
    }
}