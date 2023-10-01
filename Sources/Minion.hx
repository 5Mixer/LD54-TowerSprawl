package ;

import kha.Assets;
import kha.graphics2.Graphics;
import kha.math.Vector2i;
import kha.Color;

enum MinionState {
    Sleep;
    Idle;
    Walking(targetState: MinionState);
    CompletingTask;
}

class Minion {
    public var pos: Vector2i;
    public var state: MinionState = Idle;
    public var bedPosition: Vector2i;
    public var task: Task;
    public var food: Int = 100;
    public var maxFood: Int = 100;
    public var alive = true;
    public var heldItem: ItemType;

    var speed = 1;
    var tick = 0;
    public var mapPos: Vector2i; // Decoupled from pos as rounding/flooring jumps ahead during path finding

    public function new(pos: Vector2i) {
        this.mapPos = pos;
        this.pos = pos.mult(Game.TILE_SIZE);
        bedPosition = pos;
    }

    public function render(g: Graphics, t = 0) {
        g.drawSubImage(
            Assets.images.spritesheet,
            pos.x,
            pos.y,
            t * Game.TILE_SIZE,
            2 * Game.TILE_SIZE,
            Game.TILE_SIZE,
            Game.TILE_SIZE
        );

        if (heldItem != null) {
            heldItem.render(g, mapPos.x, mapPos.y - 1);
        }

        g.color = Color.fromBytes(59, 25, 21);
        g.fillRect(pos.x, pos.y - 2, Game.TILE_SIZE, 1);
        g.color = Color.fromBytes(178, 78, 78);
        g.fillRect(pos.x, pos.y - 2, Math.ceil(food / maxFood * Game.TILE_SIZE), 1);
        g.color = Color.White;
    }

    function walkTo(destination: Vector2i, map: TileMap, onArrival: () -> Void) {
        var path = map.pathfind(mapPos, destination);
        if (destination.x == mapPos.x && destination.y == mapPos.y) onArrival();
        if (path == null) return;
        if (path.length > 0) {
            var delta = path[0].mult(Game.TILE_SIZE).sub(pos);
            if (delta.x > 0) pos.x += speed;
            if (delta.x < 0) pos.x -= speed;
            if (delta.y > 0) pos.y += speed;
            if (delta.y < 0) pos.y -= speed;
            if (delta.x == 0 && delta.y == 0) mapPos = path[0];
        }
    }

    public function update(map: TileMap) {
        tick++;
        if (tick % 30 == 0) {
            switch (state) {
                case Sleep: {};
                case Idle:  food -= 1;
                default:    food -= 2;
            }
            if (food <= 0) {
                alive = false;
                return;
            }
        }

        switch (state) {
            case Sleep: {}
            case Idle: {
                if (food < maxFood - 20 && heldItem.name == "Mushroom") {
                    heldItem = null;
                    food += 20;
                }
                if (task != null && heldItem == null) state = Walking(CompletingTask);
            }
            case Walking(targetState): {
                switch(targetState) {
                    case Sleep: walkTo(bedPosition, map, () -> { state = targetState; });
                    case CompletingTask: walkTo(task.item.pos, map, () -> { state = targetState; });
                    default: { state = targetState; };
                }
            }
            case CompletingTask: {
                if (task.item.pos.x != mapPos.x || task.item.pos.y != mapPos.y) {
                    state = Walking(CompletingTask);
                    return;
                }
                if (task == null || task.isComplete) {
                    state = Idle;
                    task = null;
                    return;
                }
                task.progress(this);
            }
        }
    }
}