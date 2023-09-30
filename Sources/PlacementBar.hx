package ;

import kha.math.Vector2i;
import kha.System;
import kha.graphics2.Graphics;
using VectorExtension;

class PlacementBar {
    var position = new Vector2i();
    var rooms: Array<Room>;
    var contentPadding = 10;
    var interiorPadding = 10;
    var tileSize = 8;
    var windowHeight = 16 * 8 + 10 * 2; // Max room height is 16 tiles
    var pickedUpItem: Selectable;
    var pickUpOffset: Vector2i;
    var map: TileMap;

    public function new(rooms: Array<Room>, map: TileMap) {
        this.rooms = rooms;
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
            pickedUpItem.room.render(g, mapPos.x, mapPos.y);
        }
    }

    public function getPickedUpItemMapPos() {
        if (pickedUpItem != null) {
            return new Vector2i(Math.round((MouseState.pos.x - pickUpOffset.x) / tileSize), Math.round((MouseState.pos.y - pickUpOffset.y) / 8));
        }
        return null;
    }

    public function update() {
        var contents = getContents();
        if (pickedUpItem == null && MouseState.leftButtonJustDown) {
            for (item in contents) {
                if (MouseState.pos.insideRectangle(item.pos, item.size)) {
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
        pickUpOffset = new Vector2i(MouseState.pos.x - item.pos.x, MouseState.pos.y - item.pos.y);
        pickedUpItem = item;
        item.clickCallback();
    }

    public function getContents() {
        var contents = [];
        var x = contentPadding;
        var y = contentPadding;
        for (room in rooms) {
            var roomPixelWidth = room.maxWidth * tileSize;
            var roomPixelHeight = room.maxHeight * tileSize;
            var localX = x;
            var localY = y;

            contents.push(new Selectable(
                new Vector2i(localX, localY),
                new Vector2i(roomPixelWidth, roomPixelHeight),
                () -> { },
                (g) -> { room.render(g, Std.int(localX / 8), Std.int(localY / 8)); },
                room
            ));
            x += roomPixelWidth + interiorPadding;
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