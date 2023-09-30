package ;

import kha.graphics2.Graphics;
import kha.math.Vector2i;

enum SelectableContents {
    Room(room: Room);
    Item(item: ItemType);
}

class Selectable {
    public var pos: Vector2i;
    public var size: Vector2i;
    public var contents: SelectableContents;
    public var clickCallback: () -> Void;
    public var renderCallback: (g: Graphics) -> Void;

    public function new(pos: Vector2i, size: Vector2i, clickCallback: () -> Void, renderCallback: (g: Graphics) -> Void, contents: SelectableContents) {
        this.pos = pos;
        this.size = size;
        this.clickCallback = clickCallback;
        this.renderCallback = renderCallback;
        this.contents = contents;
    }
    public function onClick() {
        clickCallback();
    }
    public function render(g: Graphics) {
        renderCallback(g);
    }
}