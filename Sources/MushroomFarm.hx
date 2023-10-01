package ;

import kha.Assets;
import kha.graphics2.Graphics;

class MushroomFarm extends PlacedItem {
    public var stage = 0; // Stage 0 = Just planted. Stage 4 = ready for harvest.
    var maxStage = 4;
    var tick = 0;
    var growthProbability = 0.1;
    var variant = Math.floor(Math.random() * 3);

    override public function update() {
        tick++;

        if (stage < maxStage &&
            tick % 30 == 0 &&
            Math.random() < growthProbability
        ) {
            stage++;
        }
    }

    override public function render(g: Graphics) {
        var spriteIndex = stage + (variant * 5);
        var spriteHeight = stage < 3 ? 1 : 2;
        g.drawSubImage(
            Assets.images.spritesheet,
            pos.x * Game.TILE_SIZE,
            (pos.y + 1 - spriteHeight) * Game.TILE_SIZE,
            spriteIndex * Game.TILE_SIZE,
            7 * Game.TILE_SIZE,
            Game.TILE_SIZE,
            spriteHeight * Game.TILE_SIZE
        );
    }
}