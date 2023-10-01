package ;

import kha.Assets;
import kha.graphics2.Graphics;

class Machine extends PlacedItem {
    public var generatedItem: ItemType;
    var tick = 0;
    var collectionTask: Task;

    override public function update() {
        tick++;

        if (generatedItem == null && tick % 60 == 0) {
            generatedItem = ItemType.Wall;

            collectionTask = new Task(Harvest, this, (minion) -> {
                generatedItem = null;
                minion.heldItem = generatedItem;
                collectionTask.complete();
                collectionTask = null;
            });
        }
    }

    override public function render(g: Graphics) {
        super.render(g);
        if (generatedItem != null) {
            Game.ITEM_TYPES.get(generatedItem).render(g, (pos.x + 1) * Game.TILE_SIZE + Math.round(Math.cos(tick/20)), (pos.y + 1) * Game.TILE_SIZE - 1 - Math.round(Math.sin(tick/20)));
        }
    }

    override public function getTasks() {
        return collectionTask == null || collectionTask?.isComplete ? [] : [collectionTask];
    }
}