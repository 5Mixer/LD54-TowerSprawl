package ;

import kha.Assets;
import kha.graphics2.Graphics;

class TileMap {
    var tiles = new Array<Tile>();
    var width = 300;
    var height = 1000;
    var tileSize = 8;

    public function new() {
        for (y in 0...height) {
            for (x in 0...width) {
                tiles.push(Math.random() > .5 ? Tile.Air : Tile.Floor);
            }
        }

    }
    public function render(graphics: Graphics) {
        for (y in 0...height) {
            for (x in 0...width) {
                graphics.drawSubImage(
                    Assets.images.spritesheet,
                    x * tileSize,
                    y * tileSize,
                    tiles[y*width+x].getIndex() * tileSize,
                    0,
                    tileSize,
                    tileSize
                );
            }
        }
    }
}