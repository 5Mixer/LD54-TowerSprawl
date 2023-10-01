package ;

import kha.math.Vector2i;
import kha.Assets;
import kha.graphics2.Graphics;
using GraphicsExtension;
using Tile;
using VectorExtension;

class TileMap {
    var tiles = new Array<Tile>();
    var items = new Array<PlacedItem>();
    var width = 300;
    var height = 1000;

    public function new() {
        for (y in 0...height) {
            for (x in 0...width) {
                tiles.push(Tile.Air);
            }
        }
    }

    public function render(g: Graphics) {
        for (y in 0...height) {
            for (x in 0...width) {
                if (get(x, y) != Tile.Air)
                    g.drawTile(get(x, y), x, y);
            }
        }
        for (item in items) {
            item.render(g);
        }
    }

    public function set(x: Int, y: Int, tile: Tile) {
        tiles[y * width + x] = tile;
    }
    
    public function get(x: Int, y: Int) {
        return tiles[y * width + x];
    }

    public function addItem(item: PlacedItem) {
        items.push(item);
    }

    public function getItems() {
        return items;
    }

    public function pathfind(start: Vector2i, finish: Vector2i) {
        var openForExploration = [start];
        var reversePathways = new Map<Int, Vector2i>();
        var path = [];
        var attempts = 10000;
        while (openForExploration.length > 0 && attempts-- > 0) {
            var exploredPoint = openForExploration.shift();

            if (exploredPoint.x == finish.x && exploredPoint.y == finish.y) {
                path = [exploredPoint];
                var parent = reversePathways.get(exploredPoint.y * width + exploredPoint.x);
                while (parent != null && parent != start) {
                    path.push(parent);
                    parent = reversePathways.get(parent.y * width + parent.x);
                }
                break;
            }

            var neighbors = pathfindingNeighbors(exploredPoint);
            for (neighbor in neighbors) {
                if (reversePathways.exists(neighbor.y * width + neighbor.x)) {
                    continue;
                }
                reversePathways.set(neighbor.y * width + neighbor.x, exploredPoint);
                openForExploration.push(neighbor);
            }
        }
        path.reverse();
        return path;
    }

    public function getItem(pos: Vector2i) {
        for (item in items) {
            if (pos.insideRectangle(item.pos, item.item.spriteSheetSize)) {
                return item;
            }
        }

        return null;
    }

    function pathfindingNeighbors(position: Vector2i) {
        var neighbors = [];
        for (offset in [new Vector2i(-1, 0), new Vector2i(1, 0), new Vector2i(0, -1), new Vector2i(0, 1)]) {
            if (!get(position.x + offset.x, position.y + offset.y).isSolid() && get(position.x + offset.x, position.y + offset.y + 1) != Tile.Interior) {
                neighbors.push(new Vector2i(position.x + offset.x, position.y + offset.y));
            }
        }
        return neighbors;
    }
}