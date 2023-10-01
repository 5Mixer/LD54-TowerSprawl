package ;

import kha.graphics2.Graphics;
import kha.math.Vector2i;

class PlacedItem {
    public var item: ItemType;
    public var pos: Vector2i;

    public function new(item: ItemType, pos: Vector2i) {
        this.item = item;
        this.pos = pos;
    }

    public function render(g: Graphics) {
        item.render(g, pos.x * Game.TILE_SIZE, pos.y * Game.TILE_SIZE);
    }

    public function update() {

    }

    public function getTasks() {
        return [];
    }
}