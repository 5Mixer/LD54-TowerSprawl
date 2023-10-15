package ;

import kha.math.Vector2i;
import kha.Assets;
import kha.Color;
import kha.graphics2.Graphics;
using GraphicsExtension;
using Tile;
using VectorExtension;

class TileMap {
    var tiles = new Array<MapTile>();
    public var items = new Array<PlacedItem>();
    public var placedRooms = new Array<PlacedRoom>();
    var width = 300;
    var height = 1000;

    public function new() {
        for (y in 0...height) {
            for (x in 0...width) {
                tiles.push(new MapTile(Air));
            }
        }
    }

    public function render(g: Graphics) {
        for (y in 0...height) {
            for (x in 0...width) {
                if (get(x, y, false) != Tile.Air) {
                    g.color = tiles[y * width + x].real ? Color.White : Color.fromBytes(255, 255, 255, 100);
                    g.drawTile(get(x, y, false), x, y);
                }
            }
        }
        g.color = Color.White;
        for (item in items) {
            item.render(g);
        }
    }

    public function set(x: Int, y: Int, tile: Tile, real = true) {
        if (get(x, y, true) == tile) return; // Don't replace something real with a planned tile
        tiles[y * width + x] = new MapTile(tile, real);
    }
    
    // Could optimise out the boolean into two functions
    public function get(x: Int, y: Int, requireReal = true) {
        if (x < 0 || y < 0 || x > width || y > height) return Air;

        var tile = tiles[y * width + x];
        if (requireReal) {
            return tile.real ? tile.tile : Air;
        }
        return tile.tile;
    }

    public function multiPathfind(start: Vector2i, finishPositions: Array<Vector2i>) {
        var shortestPath = null;
        for (finishPosition in finishPositions) {
            var path = pathfind(start, finishPosition);
            if (path != null && (shortestPath == null || shortestPath.length < path.length)) {
                shortestPath = path;
            }
        }
        return shortestPath;
    }

    public function pathfind(start: Vector2i, finish: Vector2i) {
        var openForExploration = [start];
        var reversePathways = new Map<Int, Vector2i>();
        var attempts = 10000;
        while (openForExploration.length > 0 && attempts-- > 0) {
            var exploredPoint = openForExploration.shift();

            if (exploredPoint.x == finish.x && exploredPoint.y == finish.y) {
                var path = [exploredPoint];
                var parent = reversePathways.get(exploredPoint.y * width + exploredPoint.x);
                while (parent != null && parent != start) {
                    path.push(parent);
                    parent = reversePathways.get(parent.y * width + parent.x);
                }
                path.reverse();
                return path;
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
        return null;
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