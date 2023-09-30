package ;

import kha.Assets;
import kha.graphics2.Graphics;
import kha.math.Vector2i;

enum MinionState {
    Sleep;
    Idle;
    Working(at: Vector2i);
    Walking(targetState: MinionState);
}

class Minion {
    public var pos: Vector2i;
    public var state: MinionState = Idle;
    public var bedPosition: Vector2i;

    public function new(pos: Vector2i) {
        this.pos = pos;
        bedPosition = pos;
    }

    public function render(g: Graphics, t = 0) {
        g.drawSubImage(
            Assets.images.spritesheet,
            pos.x * Game.TILE_SIZE,
            pos.y * Game.TILE_SIZE,
            t * Game.TILE_SIZE,
            2 * Game.TILE_SIZE,
            Game.TILE_SIZE,
            Game.TILE_SIZE
        );
    }

    function walkTo(destination: Vector2i, map: TileMap, onArrival: () -> Void) {
        var path = map.pathfind(pos, destination);
        if (path.length > 1) {
            pos = path[0];
        } else {
            onArrival();
        }
    }

    public function update(map: TileMap) {
        switch (state) {
            case Sleep: {}
            case Idle: {}
            case Working(_): {}
            case Walking(targetState): {
                switch(targetState) {
                    case Working(location): walkTo(location, map, () -> { state = targetState; });
                    case Sleep: walkTo(bedPosition, map, () -> { state = targetState; });
                    default: { state = targetState; };
                }
            }
        }
    }
}