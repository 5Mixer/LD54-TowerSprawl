package ;

import kha.Assets;
import kha.graphics2.Graphics;
import kha.math.Vector2i;
import kha.Color;

enum MinionState {
    Sleep;
    Idle;
    Walking(targetState: MinionState);
    StoringItem;
    RetrievingItem(item: ItemType);
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
            Game.ITEM_TYPES.get(heldItem).render(g, pos.x, pos.y - Game.TILE_SIZE);
        }

        g.color = Color.fromBytes(59, 25, 21);
        g.fillRect(pos.x, pos.y - 2, Game.TILE_SIZE, 1);
        g.color = Color.fromBytes(178, 78, 78);
        g.fillRect(pos.x, pos.y - 2, Math.ceil(food / maxFood * Game.TILE_SIZE), 1);
        g.color = Color.White;
    }

    function walkTo(destinations: Array<Vector2i>, map: TileMap, onArrival: () -> Void) {
        var path = map.multiPathfind(mapPos, destinations);
        for (destination in destinations)
            if (destination.x == mapPos.x && destination.y == mapPos.y)
                onArrival();

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

    function nearestBox(map: TileMap, filter: Box -> Bool): Box {
        var boxes = map.items
            .filter(item -> item.item.type == ItemType.Box)
            .map(item -> cast(item, Box))
            .filter(box -> filter(box));
        
        var nearestBox = null;
        var minDistance = Math.POSITIVE_INFINITY;
        for (box in boxes) {
            var path = map.pathfind(box.pos, mapPos);
            if (path == null) continue;
            var distance = path.length;
            if (distance < minDistance && distance > 0) {
                minDistance = distance;
                nearestBox = box;
            }
        }
        return nearestBox;
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
                // Eat held muchrooms if hungry
                if (food <= maxFood - 20 && heldItem != null && heldItem == ItemType.Mushroom) {
                    heldItem = null;
                    food += 20;
                }
                // Store held mushrooms
                if (heldItem == Mushroom) {
                    state = Walking(StoringItem);
                    return;
                }
                // Get food if hungry
                if (food < maxFood - 20) {
                    state = Walking(RetrievingItem(Mushroom));
                }
                // Do any tasks
                if (task != null) {
                    state = Walking(CompletingTask);
                    return;
                }
                // Store other items, like walls (give building priority)
                if (heldItem != null) {
                    state = Walking(StoringItem);
                    return;
                }
            }
            case StoringItem: {
                nearestBox(map, (_) -> true).addItem(heldItem);
                heldItem = null;
                state = Idle;
            }
            case RetrievingItem(item): {
                var box = nearestBox(map, (box) -> box.contents.contains(item));
                if (box != null) {
                    heldItem = item;
                    box.contents.remove(item);
                }
                state = Idle;
            }
            case Walking(targetState): {
                switch(targetState) {
                    case Sleep: walkTo([bedPosition], map, () -> { state = targetState; });
                    case CompletingTask: walkTo(task.locations, map, () -> { state = targetState; });
                    case StoringItem: {
                        var box = nearestBox(map, (_) -> true);
                        if (box != null) {
                            walkTo([box.pos], map, () -> { state = targetState; });
                        } else {
                            state = Idle;
                        }
                    }
                    case RetrievingItem(item): {
                        var box = nearestBox(map, (box) -> box.contents.contains(item));
                        if (box != null) {
                            walkTo([box.pos], map, () -> { state = targetState; });
                        } else {
                            state = Idle;
                        }
                    }
                    default: { state = targetState; };
                }
            }
            case CompletingTask: {
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