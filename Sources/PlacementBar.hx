package ;

import kha.math.Vector2i;
import kha.System;
import kha.graphics2.Graphics;
using VectorExtension;

class PlacementBar {
    var position = new Vector2i();
    var rooms: Array<Room>;
    var itemTypes: Array<ItemType>;
    var contentPadding = 2;
    var interiorPadding = 2;
    var windowHeight = 16 * Game.PREVIEW_TILE_SIZE + 3*Game.PREVIEW_TILE_SIZE; // Max room height is 16 tiles, plus padding
    var pickedUpItem: Selectable;
    var pickUpOffset: Vector2i;
    var map: TileMap;

    public function new(rooms: Array<Room>, itemTypes: Array<ItemType>, map: TileMap) {
        this.rooms = rooms;
        this.itemTypes = itemTypes;
        this.map = map;
    }

    public function render(g: Graphics) {
        g.color = kha.Color.fromBytes(216, 227, 224);
        g.fillRect(position.x, position.y, getWidth(), getHeight());
        g.color = kha.Color.White;

        for (item in getContents()) {
            item.render(g);
        }

        if (pickedUpItem != null) {
            var mapPos = getPickedUpItemMapPos();
            var validPlacement = pickedUpItem.room.canBePlacedAtMap(map, mapPos.x, mapPos.y);
            g.color = validPlacement ? kha.Color.fromBytes(114, 224, 148, 200) : kha.Color.fromBytes(227, 91, 56, 200);
            pickedUpItem.room.render(g, mapPos.x, mapPos.y);
            g.color = kha.Color.White;
        }
    }

    public function getPickedUpItemMapPos() {
        if (pickedUpItem != null) {
            return new Vector2i(Std.int((MouseState.worldPos().x/Game.TILE_SIZE) - pickUpOffset.x/Game.PREVIEW_TILE_SIZE), Std.int((MouseState.worldPos().y/Game.TILE_SIZE) - pickUpOffset.y/Game.PREVIEW_TILE_SIZE));
        }
        return null;
    }

    public function update() {
        var contents = getContents();
        if (pickedUpItem == null && MouseState.leftButtonJustDown) {
            for (item in contents) {
                if (MouseState.worldPos().insideRectangle(item.pos, item.size)) {
                    onPickUp(item);
                }
            }
        }
        if (!MouseState.isLeftButtonDown) {
            if (pickedUpItem != null) {
                var mapPos = getPickedUpItemMapPos();
                if (pickedUpItem.room.canBePlacedAtMap(map, mapPos.x, mapPos.y)) {
                    pickedUpItem.room.stampOnMap(map, mapPos.x, mapPos.y);
                }
            }
            pickedUpItem = null;
        }
    }

    function onPickUp(item: Selectable) {
        pickUpOffset = new Vector2i(MouseState.worldPos().x - item.pos.x, MouseState.worldPos().y - item.pos.y);
        pickedUpItem = item;
        item.clickCallback();
    }

    public function getContents() {
        var contents = [];
        var x = contentPadding;
        var y = contentPadding;
        for (room in rooms) {
            var xCopy = x;
            contents.push(new Selectable(
                new Vector2i(x, y),
                new Vector2i(room.maxWidth * Game.PREVIEW_TILE_SIZE, room.maxHeight * Game.PREVIEW_TILE_SIZE),
                () -> { },
                function(g) { room.renderSmall(g, xCopy, y); },
                room
            ));
            x += room.maxWidth * Game.PREVIEW_TILE_SIZE + interiorPadding;
        }
        for (item in itemTypes) {
            var xCopy = x;

            x += item.spriteSheetSize.x;
        }
        return contents;
    }

    function getWidth() {
        return System.windowWidth();
    }
    function getHeight() {
        return windowHeight;
    }
}