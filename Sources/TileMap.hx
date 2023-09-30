package ;

import kha.Assets;
import kha.graphics2.Graphics;
using GraphicsExtension;

class TileMap {
    var tiles = new Array<Tile>();
    var width = 300;
    var height = 1000;

    public function new() {
        for (y in 0...height) {
            for (x in 0...width) {
                tiles.push(Tile.Air);
            }
        }
    }

    public function render(graphics: Graphics) {
        for (y in 0...height) {
            for (x in 0...width) {
                if (get(x, y) != Tile.Air)
                    graphics.drawTile(get(x, y), x, y);
            }
        }
    }

    public function set(x: Int, y: Int, tile: Tile) {
        tiles[y * width + x] = tile;
    }
    
    public function get(x: Int, y: Int) {
        return tiles[y * width + x];
    }
}